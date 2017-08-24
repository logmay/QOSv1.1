function cm = bwr(m)
    % color map

% Copyright 2015 Yulin Wu, Institute of Physics, Chinese  Academy of Sciences
% mail4ywu@gmail.com/mail4ywu@icloud.com
  if nargin == 0
      m = 128;
  end
  r= [100,115.243233073423,127.410047202077,139.432566204651,151.978461844212,163.826693930955,174.052279705258,...
      182.599768820124,189.372976961139,195.551820735323,201.558667914690,207.530165209091,213.295907362377,...
      218.010667068049,222.965218228971,228.839756356495,233.345059297910,238.941678986901,242.786491652684,...
      245.109853497367,248.115549862630,250.071895423648,251.994086523498,253.916278478594,255,...
      255,255,255,254.999999996601,254.809373820253,252.883286471190,250.353593829519,246.254354996906,...
      240.496238903476,235.355426477747,228.975684092076,222.678641278666,215.880439699766,207.971082754703,...
      199.296697712764,189.544533423982,179.601427217327,169.190141919323,158.507491165724,...
      147.100432808879,135.425940722122,123.244929630345,110.181422242023,97.4652693870009,...
      85.0814685029331,73.8953696262180,64.5217243407044,57.5446413881431,51.1663932809028,45.7030835810550,...
      40.5400664047898,34.7146736607915,30.1128542584768,24.8938430288442,20.1450100254762,15.7684538637262,...
      10.8209039824748,5.99529212975643,0]/255;

  g = [0,2.67049486606099,6.29394132628989,10.1409897280420,13.9655705092394,18.5370363793962,25.0127322632049,...
      33.0643078772473,42.9320143135744,54.3087989914680,65.8708147700806,77.6252696436338,89.1426149519286,...
      100.164405839562,111.342247610493,122.272733760663,133.452180025207,144.660135620985,155.265483623888,...
      165.274610449966,174.526212636327,183.398165196167,192.112145623467,200.825844118757,209.297203695610,...
      216.407410569786,222.695613183279,228.004979243216,232.612163586759,237.241802834936,241.214712251430,...
      243.902527869783,244.882789209397,244.058786878913,241.615311891604,238.732026143795,235.848682818900,...
      232.600755792406,228.756629178250,224.366983007838,219.721874503063,214.550939853437,209.542623423937,...
      204.274106554381,198.038130291012,190.883157689779,183.283832454461,175.001633444297,166.956648367986,...
      158.894723623865,151.302216941916,143.810887269500,136.548648076797,129.227691043518,122.067153642248,...
      114.724088101280,107.131774365070,99.6536076040412,91.8233110754230,83.2269016241925,74.3762838596939,...
      65.2111282213435,55.7863374698039,41]/255;
  b = [30,31.7454896943404,32.3481675079442,34.2763771161589,36.1985683166457,38.2967155982658,42.1447009430924,...
      46.3616577271569,50.4268898625734,56.4280931860995,62.0292573859686,67.2698215274896,73.5587673559735,...
      80.2148371014344,87.7713058989928,96.3682729242681,105.067054136426,113.459575842546,122.529401547891,...
      132.330220468358,142.653527171667,153.508816272078,164.485464022825,175.529504878627,186.331574018576,...
      196.556976165438,205.890741720869,214.260485028154,222.169936198369,230.098967432596,237.087771401595,...
      242.430808377755,245.686523825283,247.000046960496,247.000000000005,246.999999991060,246.682799476742,...
      244.761282290551,242.839091153444,240.559428258994,236.765325842673,234.798009598132,231.993459433229,...
      227.978237292806,224.981021436760,220.896358155094,216.491824557565,212.647354949033,208.038181569437,...
      204.193912625678,199.433717688078,195.349206349204,191.264550264550,187.179892893610,183.599534234874,...
      179.755067791149,174.459671848220,167.437188466022,157.745116833170,146.701847365076,134.665995818310,...
      122.083326965366,109.944394211149,84]/255;
  x = linspace(0,1,64);
  cm = ones(m,3);
  xi = linspace(0,1,m);
  cm(:,1) = interp1(x,r,xi);
  cm(:,2) = interp1(x,g,xi);
  cm(:,3) = interp1(x,b,xi);
  cm = flipud(cm);
end