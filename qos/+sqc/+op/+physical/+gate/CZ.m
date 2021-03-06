function g = CZ(q1, q2)
	% controled Z gate:
    % [1,0,0,0
    %  0,1,0,0
    %  0,0,1,0
    %  0,0,0,-1];
    
% Copyright 2017 Yulin Wu, University of Science and Technology of China
% mail4ywu@gmail.com/mail4ywu@icloud.com
	import sqc.op.physical.gate.*
       
	g = ACZ(q1, q2);
	
	% todo...
%	switch scz.typ
%		case {'acz','ACZ'}
%			g = ACZ(q1, q2);
%		otherwise
%			error('unrecognized ACZ gate type: %s, available z gate options are: acz',...
%				scz.typ);
%	end
end
