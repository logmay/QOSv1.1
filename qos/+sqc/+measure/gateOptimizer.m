classdef gateOptimizer < qes.measurement.measurement
	% do gate optimization
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com

	methods(Static = true)
		function xyGateOptWithDrag(qubit,numGates,numReps,rAvg,maxIter)
            if nargin < 5
                maxIter = 20;
            end

			import sqc.op.physical.*
			if ischar(qubit)
				qubit = sqc.util.qName2Obj(qubit);
			end
			if ~qubit.qr_xy_dragPulse
				error('DRAG disabled, can not do DRAG optimization, checking qubit settings.');
            end
			qubit.r_avg = rAvg;
            
			R = sqc.measure.randBenchMarking4Opt(qubit,numGates,numReps);
			
			detune = qes.expParam(qubit,'f01');
			detune.offset = qubit.f01;
			
			XY2_amp = qes.expParam(qubit,'g_XY2_amp');
			XY2_amp.offset = qubit.g_XY2_amp;
			
			XY_amp = qes.expParam(qubit,'g_XY_amp');
			XY_amp.offset = qubit.g_XY_amp;
			
			alpha = qes.expParam(qubit,'qr_xy_dragAlpha');
			alpha.offset = 0.5;
            
            QS = qes.qSettings.GetInstance();

			opts = optimset('Display','none','MaxIter',maxIter,'TolX',0.0001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			if isempty(qubit.g_XY_typ) || strcmp(qubit.g_XY_typ,'pi')
				f = qes.expFcn([detune,XY2_amp,XY_amp,alpha],R);
                x0 = [0,0,0,0];
                fval0 = f(x0);
				[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
					x0,...
					[-2e6,-qubit.g_XY2_amp*0.05,-qubit.g_XY_amp*0.05,-0.25],...
					[2e6,qubit.g_XY2_amp*0.05,qubit.g_XY_amp*0.05,0.25],...
					opts);
                if fval > fval0
                    error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
                end
                QS.saveSSettings({qubit.name,'f01'},qubit.f01+optParams(1));
                QS.saveSSettings({qubit.name,'g_XY2_amp'},qubit.g_XY2_amp+optParams(2));
                QS.saveSSettings({qubit.name,'g_XY_amp'},qubit.g_XY_amp+optParams(3));
                QS.saveSSettings({qubit.name,'qr_xy_dragAlpha'},qubit.qr_xy_dragAlpha+optParams(4));
			elseif strcmp(qubit.g_XY_typ,'hPi')
				f = qes.expFcn([detune,XY2_amp,alpha],R);
                x0 = [0,0,0];
                fval0 = f(x0);
				[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
					x0,...
					[-2e6,-qubit.g_XY2_amp*0.05,-0.25],...
					[2e6,qubit.g_XY2_amp*0.05,0.25],...
					opts);
                if fval > fval0
                    error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
                end
                QS.saveSSettings({qubit.name,'f01'},qubit.f01+optParams(1));
                QS.saveSSettings({qubit.name,'g_XY2_amp'},qubit.g_XY2_amp+optParams(2));
                QS.saveSSettings({qubit.name,'qr_xy_dragAlpha'},qubit.qr_xy_dragAlpha+optParams(3));
			else
				error('unrecognized X gate type: %s, available x gate options are: pi and hPi',...
					qubit.g_XY_typ);
            end
			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['XYGateOpt_',TimeStamp,'.mat'];
			figFileName = ['XYGateOpt_',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'xyGateOptWithDrag';
            save(fullfile(dataPath,dataFileName),'optParams','sessionSettings','hwSettings','notes');
			try
				saveas(gcf,figFileName);
			catch
			end
		end
		function xyGateOptNoDrag(qubit,numGates,numReps,rAvg,maxIter)
            if nargin < 4
                maxIter = 20;
            end
 
			import sqc.op.physical.*
			if ischar(qubit)
				qubit = sqc.util.qName2Obj(qubit);
			end
			if qubit.qr_xy_dragPulse
				error('DRAG enable, can not do no DRAG optimization, checking qubit settings.');
			end
			qubit.r_avg = rAvg;
			R = sqc.measure.randBenchMarking4Opt(qubit,numGates,numReps);
			
			detune = qes.expParam(qubit,'f01');
			detune.offset = qubit.f01;
			
			XY2_amp = qes.expParam(qubit,'g_XY2_amp');
			XY2_amp.offset = qubit.g_XY2_amp;
			
			XY_amp = qes.expParam(qubit,'g_XY_amp');
			XY_amp.offset = qubit.g_XY_amp;
            
            QS = qes.qSettings.GetInstance();

			opts = optimset('Display','none','MaxIter',maxIter,'TolX',0.0001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			if isempty(qubit.g_XY_typ) || strcmp(qubit.g_XY_typ,'pi')
				f = qes.expFcn([detune,XY2_amp,XY_amp],R);
                x0 = [0,0,0];
                fval0 = f(x0);
				[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
					x0,...
					[-2e6,-qubit.g_XY2_amp*0.05,-qubit.g_XY_amp*0.05],...
					[2e6,qubit.g_XY2_amp*0.05,qubit.g_XY_amp*0.05],...
					opts);
                if fval > fval0
                    error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
                end
                QS.saveSSettings({qubit.name,'f01'},qubit.f01+optParams(1));
                QS.saveSSettings({qubit.name,'g_XY2_amp'},qubit.g_XY2_amp+optParams(2));
                QS.saveSSettings({qubit.name,'g_XY_amp'},qubit.g_XY_amp+optParams(3));
			elseif strcmp(qubit.g_XY_typ,'hPi')
				f = qes.expFcn([detune,XY2_amp,alpha],R);
                x0 = [0,0];
                fval0 = f(x0);
				[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
					x0,...
					[-2e6,-qubit.g_XY2_amp*0.05],...
					[2e6,qubit.g_XY2_amp*0.05],...
					opts);
                if fval > fval0
                    error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
                end
                QS.saveSSettings({qubit.name,'f01'},qubit.f01+optParams(1));
                QS.saveSSettings({qubit.name,'g_XY2_amp'},qubit.g_XY2_amp+optParams(2));
			else
				error('unrecognized X gate type: %s, available x gate options are: pi and hPi',...
					qubit.g_XY_typ);
            end
			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['XYGateOpt_',TimeStamp,'.mat'];
			figFileName = ['XYGateOpt_',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'xyGateOptNoDrag';
            save(fullfile(dataPath,dataFileName),'optParams','sessionSettings','hwSettings','notes');
			try
				saveas(gcf,figFileName);
			catch
			end
        end
		
		function zGateOpt(qubit,numGates,numReps,rAvg,maxIter)
            if nargin < 4
                maxIter = 20;
            end
 
			import sqc.op.physical.*
			if ischar(qubit)
				qubit = sqc.util.qName2Obj(qubit);
			end
			if ~strcmp(qubit.g_Z_typ,'z')
				error('zGateOpt perform Z gate optimization by tunning pulse callibration paraeters, it is applicable only when Z gate is implemented by z pulse, check Z gate settings.');
			end
			qubit.r_avg = rAvg;
			Z = sqc.op.physical.gate.Z(qubit);
			R = sqc.measure.randBenchMarking4Opt(qubit,numGates,numReps,Z);
            
            QS = qes.qSettings.GetInstance();
			
			Z_amp = qes.expParam(Z,'amp');
			Z_amp.offset = qubit.g_Z_z_amp;
			
 			da = qes.qHandle.FindByClassProp('qes.hwdriver.hardware',...
                         'name',qubit.channels.z_pulse.instru);
            z_daChnl = da.GetChnl(qubit.channels.z_pulse.chnl);
%             
%             xfrFuncSettings = QS.loadHwSettings({'obj.qubit.channels.z_pulse.instru',...
%                 'xfrFunc'});
%             xfrFunc = xfrFuncSettings{obj.qubit.channels.z_pulse.chnl};
%            xfrFuncSetting = struct('lowPassFilters','xfrFuncs');
%            xfrFuncSetting.lowPassFilters = {struct('type','function',...
%                'funcName','com.qos.waveform.XfrFuncFastGaussianFilter',...
%                'bandWidth','0.130')};
%            xfrFuncSetting.xfrFuncs = {struct('type','function',...
%                'funcName','qes.waveform.xfrFunc.gaussianExp',...
%                'bandWidth',0.25,...
%                'rAmp',[0.0155],...
%                'td',[800])};
				
			lowPassFilterSettings0 = struct('type','function',...
					'funcName','com.qos.waveform.XfrFuncFastGaussianFilter',...
					'bandWidth',0.130);
            xfrFuncsSettings0 = struct('type','function',...
                'funcName','qes.waveform.xfrFunc.gaussianExp',...
                'bandWidth',0.25,...
                'rAmp',[0.0155],...
                'td',[800]);
			
			rAmp = qes.util.hvar(xfrFuncsSettings0.rAmp(1));
			td = qes.util.hvar(xfrFuncsSettings0.td(1));
			function setXfrFunc()
				lowPassFilter = qes.util.xfrFuncBuilder(lowPassFilterSettings0);
				xfrFunc_ = qes.util.xfrFuncBuilder(...
					struct('type','function',...
					'funcName','qes.waveform.xfrFunc.gaussianExp',...
					'bandWidth',0.25,...
					'rAmp',[rAmp.val],...
					'td',[td.val]));
				xfrFunc = lowPassFilter.add(xfrFunc_.inv());
				z_daChnl.xfrFunc = xfrFunc;
			end
            
			p_rAmp = qes.expParam(rAmp,'val');
			p_rAmp.offset = rAmp.val;
            p_rAmp.callbacks = {@(x)setXfrFunc()};
            setXfrFunc()
			
			p_td = qes.expParam(td,'val');
            p_td.callbacks = {@(x)setXfrFunc()};
			p_td.offset = td.val;
			
		
			opts = optimset('Display','none','MaxIter',maxIter,'TolX',0.0001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
			
				f = qes.expFcn([Z_amp,p_rAmp,p_td],R);
                x0 = [0,0,0];
                fval0 = f(x0);
				[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
					x0,...
					[-qubit.g_Z_z_amp*0.05,-0.03,100],...
					[qubit.g_Z_z_amp*0.05,0.03,1500],...
					opts);
                if fval > fval0
                    error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
                end
                
			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['ZGateOpt_',TimeStamp,'.mat'];
			figFileName = ['ZGateOpt_',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'ZGateOpt';
            save(fullfile(dataPath,dataFileName),'optParams','sessionSettings',...
				'hwSettings','lowPassFilterSettings0','xfrFuncsSettings0','notes');
			try
				saveas(gcf,figFileName);
			catch
			end
        end
        
        % function czOptPhase(qubits,numGates,numReps, rAvg, maxFEval)
        function czOptPhase(qubits,numGates, rAvg, maxFEval)
            if nargin < 5
                maxFEval = 100;
            end
			
			import sqc.op.physical.*
			if ~iscell(qubits) || numel(qubits) ~= 2
				error('qubits not a cell of 2.');
			end
			for ii = 1:numel(qubits)
				if ischar(qubits{ii})
					qubits{ii} = sqc.util.qName2Obj(qubits{ii});
                end
                qubits{ii}.r_avg = rAvg;
            end

			aczSettingsKey = sprintf('%s_%s',qubits{1}.name,qubits{2}.name);
			QS = qes.qSettings.GetInstance();
			scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
			aczSettings = sqc.qobj.aczSettings();
			fn = fieldnames(scz);
			for ii = 1:numel(fn)
				aczSettings.(fn{ii}) = scz.(fn{ii});
			end
			qubits{1}.aczSettings = aczSettings;
			
			% R = sqc.measure.randBenchMarking4Opt(qubits,numGates,numReps);
            R = sqc.measure.randBenchMarkingFS(qubits,numGates);
			
			phase1 = qes.expParam(aczSettings,'dynamicPhase(1)');
			phase1.offset = aczSettings.dynamicPhase(1);
			
			phase2 = qes.expParam(aczSettings,'dynamicPhase(2)');
			phase2.offset = aczSettings.dynamicPhase(2);
            
			f = qes.expFcn([phase1,phase2],R);
            
% 			x0 = [0,0];
% 			fval0 = f(x0);
%             opts = optimset('Display','none','MaxIter',maxIter,'TolX',0.0001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
% 			[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
%                     x0,...
% 					[-pi,-pi],...
% 					[pi,pi],...
% 					opts);
                
            
            x0 = [-pi,-pi;...
                    -pi,pi;...
                    0,pi]/2;
            tolX = [pi,pi]/5e4;
            tolY = [1e-4];
            
            h = qes.ui.qosFigure(sprintf('Gate Optimizer | %s%s CZ', qubits{1}.name, qubits{2}.name),false);
            axs(1) = subplot(3,1,3,'Parent',h);
            axs(2) = subplot(3,1,2);
            axs(3) = subplot(3,1,1);
            [optParams, x_trace, y_trace, n_feval] = qes.util.NelderMead(f.fcn, x0, tolX, tolY, maxFEval, axs);
            fval = y_trace(end);
            fval0 = y_trace(1);

			if fval > fval0
               error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
            end
            % note: aczSettings is a handle class
            aczSettings.dynamicPhase = aczSettings.dynamicPhase - 2*pi*floor(aczSettings.dynamicPhase/(2*pi));
			QS.saveSSettings({'shared','g_cz',aczSettingsKey,'dynamicPhase'},...
								aczSettings.dynamicPhase);
			
			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['CZGateOpt',TimeStamp,'.mat'];
			figFileName = ['CZGateOpt',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'CZGateOpt';
            save(fullfile(dataPath,dataFileName),'optParams','x_trace','y_trace','sessionSettings','hwSettings','notes');
			try
				saveas(h,fullfile(dataPath,figFileName));
			catch
			end
        end
        
        % function czOptPhaseAmp(qubits,numGates, rAvg, maxFEval)
        function czOptPhaseAmp(qubits,numGates, numReps,rAvg, maxFEval)
            if nargin < 5
                maxFEval = 100;
            end
			
			import sqc.op.physical.*
			if ~iscell(qubits) || numel(qubits) ~= 2
				error('qubits not a cell of 2.');
			end
			for ii = 1:numel(qubits)
				if ischar(qubits{ii})
					qubits{ii} = sqc.util.qName2Obj(qubits{ii});
                end
                qubits{ii}.r_avg = rAvg;
            end

			aczSettingsKey = sprintf('%s_%s',qubits{1}.name,qubits{2}.name);
			QS = qes.qSettings.GetInstance();
			scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
			aczSettings = sqc.qobj.aczSettings();
			fn = fieldnames(scz);
			for ii = 1:numel(fn)
				aczSettings.(fn{ii}) = scz.(fn{ii});
			end
			qubits{1}.aczSettings = aczSettings;
			
			R = sqc.measure.randBenchMarking4Opt(qubits,numGates,numReps);
            % R = sqc.measure.randBenchMarkingFS(qubits,numGates);
			
			phase1 = qes.expParam(aczSettings,'dynamicPhase(1)');
			phase1.offset = aczSettings.dynamicPhase(1);
			
			phase2 = qes.expParam(aczSettings,'dynamicPhase(2)');
			phase2.offset = aczSettings.dynamicPhase(2);
            
            amplitude = qes.expParam(aczSettings,'amp');
			amplitude.offset = aczSettings.amp;
            
			f = qes.expFcn([phase1,phase2,amplitude],R);

            x0 = [-0.1,-0.1,-0.02*aczSettings.amp;...
                    -0.1,-0.1,0.02*aczSettings.amp;...
                    -0.1,0.1,0.02*aczSettings.amp;...
                    0.1,0.1,0.02*aczSettings.amp];
            tolX = [pi/5e4,pi/5e4,1];
            tolY = [1e-4];
            
            h = qes.ui.qosFigure(sprintf('Gate Optimizer | %s%s CZ', qubits{1}.name, qubits{2}.name),false);
            axs(1) = subplot(4,1,4,'Parent',h);
            axs(2) = subplot(4,1,3);
            axs(3) = subplot(4,1,2);
            axs(4) = subplot(4,1,1);
            [optParams, x_trace, y_trace, n_feval] = qes.util.NelderMead(f.fcn, x0, tolX, tolY, maxFEval, axs);
            fval = y_trace(end);
            fval0 = y_trace(1);

			if fval > fval0
               error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
            end
            % note: aczSettings is a handle class
            aczSettings.dynamicPhase = aczSettings.dynamicPhase - 2*pi*floor(aczSettings.dynamicPhase/(2*pi));
			QS.saveSSettings({'shared','g_cz',aczSettingsKey,'dynamicPhase'},...
								aczSettings.dynamicPhase);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'amp'},...
								aczSettings.amp);
			
			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['CZGateOpt',TimeStamp,'.mat'];
			figFileName = ['CZGateOpt',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'CZGateOpt';
            save(fullfile(dataPath,dataFileName),'optParams','x_trace','y_trace','sessionSettings','hwSettings','notes');
			try
				saveas(h,fullfile(dataPath,figFileName));
			catch
			end
        end
        
        function czOpt(qubits,numGates, rAvg, maxFEval)
            if nargin < 5
                maxFEval = 100;
            end
			
			import sqc.op.physical.*
			if ~iscell(qubits) || numel(qubits) ~= 2
				error('qubits not a cell of 2.');
			end
			for ii = 1:numel(qubits)
				if ischar(qubits{ii})
					qubits{ii} = sqc.util.qName2Obj(qubits{ii});
                end
                qubits{ii}.r_avg = rAvg;
            end

			aczSettingsKey = sprintf('%s_%s',qubits{1}.name,qubits{2}.name);
			QS = qes.qSettings.GetInstance();
			scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
			aczSettings = sqc.qobj.aczSettings();
			fn = fieldnames(scz);
			for ii = 1:numel(fn)
				aczSettings.(fn{ii}) = scz.(fn{ii});
			end
			qubits{1}.aczSettings = aczSettings;
			
			% R = sqc.measure.randBenchMarking4Opt(qubits,numGates,10);
            R = sqc.measure.randBenchMarkingFS(qubits,numGates);
			
			phase1 = qes.expParam(aczSettings,'dynamicPhase(1)');
			phase1.offset = aczSettings.dynamicPhase(1);
			
			phase2 = qes.expParam(aczSettings,'dynamicPhase(2)');
			phase2.offset = aczSettings.dynamicPhase(2);
            
            amplitude = qes.expParam(aczSettings,'amp');
			amplitude.offset = aczSettings.amp;
            
            thf = qes.expParam(aczSettings,'thf');
			thf.offset = aczSettings.thf;
            
            thi = qes.expParam(aczSettings,'thi');
			thi.offset = aczSettings.thi;
            
            lam2 = qes.expParam(aczSettings,'lam2');
			lam2.offset = aczSettings.lam2;
            
            lam3 = qes.expParam(aczSettings,'lam3');
			lam3.offset = aczSettings.lam3;
            
			f = qes.expFcn([phase1,phase2,amplitude,thf,thi,lam2,lam3],R);

            x0 = [-0.1,-0.1,-0.02*aczSettings.amp,-0.2,-0.2,-0.2,-0.2;...
                    -0.1,-0.1,-0.02*aczSettings.amp,-0.2,-0.2,-0.2,0.2;...
                    -0.1,-0.1,-0.02*aczSettings.amp,-0.2,-0.2,0.2,0.2;...
                    -0.1,-0.1,-0.02*aczSettings.amp,-0.2,0.2,0.2,0.2;...
                    -0.1,-0.1,-0.02*aczSettings.amp,0.2,0.2,0.2,0.2;...
                    -0.1,-0.1,0.02*aczSettings.amp,0.2,0.2,0.2,0.2;...
                    -0.1,0.1,0.02*aczSettings.amp,0.2,0.2,0.2,0.2;...
                    0.1,0.1,0.02*aczSettings.amp,0.2,0.2,0.2,0.2];
            
            tolX = [pi/5e4,pi/5e4,1,1e-4,1e-4,1e-4,1e-4];
            tolY = [1e-4];
            
            h = qes.ui.qosFigure(sprintf('Gate Optimizer | %s%s CZ', qubits{1}.name, qubits{2}.name),false);
            axs(1) = subplot(4,2,8,'Parent',h);
            axs(2) = subplot(4,2,7);
            axs(3) = subplot(4,2,6);
            axs(4) = subplot(4,2,5);
            axs(5) = subplot(4,2,4);
            axs(6) = subplot(4,2,3);
            axs(7) = subplot(4,2,2);
            axs(8) = subplot(4,2,1);
            [optParams, x_trace, y_trace, n_feval] = qes.util.NelderMead(f.fcn, x0, tolX, tolY, maxFEval, axs);
            fval = y_trace(end);
            fval0 = y_trace(1);

			if fval > fval0
               error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
            end
            % note: aczSettings is a handle class
            aczSettings.dynamicPhase = aczSettings.dynamicPhase - 2*pi*floor(aczSettings.dynamicPhase/(2*pi));
			QS.saveSSettings({'shared','g_cz',aczSettingsKey,'dynamicPhase'},...
								aczSettings.dynamicPhase);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'amp'},aczSettings.amp);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'thf'},aczSettings.thf);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'thi'},aczSettings.thi);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'lam2'},aczSettings.lam2);
            QS.saveSSettings({'shared','g_cz',aczSettingsKey,'lam3'},aczSettings.lam3);

			dataPath = QS.loadSSettings('data_path');
			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
			dataFileName = ['CZGateOpt',TimeStamp,'.mat'];
			figFileName = ['CZGateOpt',TimeStamp,'.fig'];
			sessionSettings = QS.loadSSettings;
			hwSettings = QS.loadHwSettings;
			notes = 'CZGateOpt';
            save(fullfile(dataPath,dataFileName),'optParams','x_trace','y_trace','sessionSettings','hwSettings','notes');
			try
				saveas(h,fullfile(dataPath,figFileName));
			catch
			end
        end
        
%         function czOptPhaseAmp(qubits,numGates,numReps, rAvg, maxIter)
%             if nargin < 5
%                 maxIter = 20;
%             end
% 			
% 			import sqc.op.physical.*
% 			if ~iscell(qubits) || numel(qubits) ~= 2
% 				error('qubits not a cell of 2.');
% 			end
% 			for ii = 1:numel(qubits)
% 				if ischar(qubits{ii})
% 					qubits{ii} = sqc.util.qName2Obj(qubits{ii});
%                 end
%                 qubits{ii}.r_avg = rAvg;
%             end
% 
% 			aczSettingsKey = sprintf('%s_%s',qubits{1}.name,qubits{2}.name);
% 			QS = qes.qSettings.GetInstance();
% 			scz = QS.loadSSettings({'shared','g_cz',aczSettingsKey});
% 			aczSettings = sqc.qobj.aczSettings();
% 			fn = fieldnames(scz);
% 			for ii = 1:numel(fn)
% 				aczSettings.(fn{ii}) = scz.(fn{ii});
% 			end
% 			qubits{1}.aczSettings = aczSettings;
% 			
% 			R = sqc.measure.randBenchMarking4Opt(qubits,numGates,numReps);
% 			
% 			phase1 = qes.expParam(aczSettings,'dynamicPhase(1)');
% 			phase1.offset = aczSettings.dynamicPhase(1);
% 			
% 			phase2 = qes.expParam(aczSettings,'dynamicPhase(2)');
% 			phase2.offset = aczSettings.dynamicPhase(2);
% 			
% 			amplitude = qes.expParam(aczSettings,'amp');
% 			amplitude.offset = aczSettings.amp;
% 
% 			opts = optimset('Display','none','MaxIter',maxIter,'TolX',0.0001,'TolFun',0.01,'PlotFcns',{@optimplotfval});
% 			f = qes.expFcn([phase1,phase2,amplitude],R);
% 			x0 = [0,0,0];
% 			fval0 = f(x0);
% 			[optParams,fval,exitflag,output] = qes.util.fminsearchbnd(f.fcn,...
%                     x0,...
% 					[-pi,-pi,-aczSettings.amp*0.05],...
% 					[pi,pi,aczSettings.amp*0.05],...
% 					opts);
%             
% 			if fval > fval0
%                error('Optimization failed: final fidelity worse than initial fidelity, registry not updated.');
%             end
%             % note: aczSettings is a handle class
% 			QS.saveSSettings({'shared','g_cz',aczSettingsKey,'dynamicPhase'},...
% 								aczSettings.dynamicPhase);
%             QS.saveSSettings({'shared','g_cz',aczSettingsKey,'amp'},aczSettings.amp);
% 			
% 			dataPath = QS.loadSSettings('data_path');
% 			TimeStamp = datestr(now,'_yymmddTHHMMSS_');
% 			dataFileName = ['CZGateOpt_',TimeStamp,'.mat'];
% 			figFileName = ['CZGateOpt_',TimeStamp,'.fig'];
% 			sessionSettings = QS.loadSSettings;
% 			hwSettings = QS.loadHwSettings;
% 			notes = 'CZGateOpt';
%             save(fullfile(dataPath,dataFileName),'optParams','sessionSettings','hwSettings','notes');
% 			try
% 				saveas(gcf,figFileName);
% 			catch
% 			end
%         end
    end
end