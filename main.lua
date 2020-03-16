function love.load()
  love.audio.setEffect('myEffect', {
      type = 'reverb',
      decaytime = 3,
      gain = 1.2
  });
  
  
  audioExample = love.audio.newSource("meeyo.wav", "static");
  audioExample:setVolume(0.7);
  audioExample:setEffect('myEffect');
  audioExample:play();
  
  audioMn = love.audio.newSource("tick.wav", "static");
  audioMn:setEffect('myEffect');

  pitch = 1.0;
  bpm = 110;
  beat = 0;
  beatDV = 0;
  lastDV = 0;
  measure = 0;
  time = 0;
  tick = 0;
  offset = 0.1;
  isMetronome = false;
  
  samples = audioExample:tell("samples");
  seconds = audioExample:tell("seconds");
  
  playingStatus = audioExample:isPlaying();
  lerpSeconds = 0;
  calculatedSeconds = 0;
  difference = 0;
  
  icon = love.graphics.newImage("icon.png");
  font = love.graphics.newFont("consola.ttf");
  love.graphics.setFont(font);
end



function lerp(v0, v1, t, dt)
  return v0 + (v1 - v0) * t * dt;
end

function refloat(v, pointPlaces)
  return math.floor(v * math.pow(10, pointPlaces)) / math.pow(10, pointPlaces);
end

function love.update(dt)
  time = time + dt;
  tick = tick + dt;
  
  lerpSeconds = refloat(lerp(lerpSeconds, seconds, 18, dt), 3);
  calculatedSeconds = lerpSeconds + offset;
  
  difference = refloat(time - seconds, 5);
  
  beat = math.floor(calculatedSeconds / (60 / bpm));
  beatDV = (beat % 4) + 1;
  
  if(isMetronome == true) then
    if(beatDV ~= lastDV) then
      if(beatDV == 1) then
        audioMn:setPitch(1.5);
      else
        audioMn:setPitch(1.0);
      end
      audioMn:play();
    end
  end
  
  lastDV = beatDV;
  
  measure = math.floor((beat/4));
      
  if(tick > 0.04) then
    samples = audioExample:tell("samples");
    seconds = audioExample:tell("seconds");
    playingStatus = audioExample:isPlaying();
    tick = 0;
  end
end

function love.keypressed(k)
  if(k == "space") then
    if(audioExample:isPlaying() == true) then
      audioExample:pause();
    else
      audioExample:play();
    end
  elseif(k == "o") then
    pitch = pitch - 0.05;
    audioExample:setPitch(pitch);
  elseif(k == "p") then
    pitch = pitch + 0.05;
    audioExample:setPitch(pitch);
  elseif(k == "u") then
    offset = offset + 0.05;
  elseif(k == "i") then
    offset = offset - 0.05;
  elseif(k == "q") then
    audioExample:stop();
  elseif(k == "m") then
    isMetronome = not isMetronome;
  end
end

function love.draw()
  love.graphics.printf("realtime              : " .. time, 10, 10, 300);
  love.graphics.printf("current audio samples : " .. samples, 10, 25, 300);
  love.graphics.printf("current audio time    : " .. seconds, 10, 40, 300);
  love.graphics.printf("current lerp time     : " .. calculatedSeconds, 10, 55, 300);
  love.graphics.printf("current audio state   : " .. tostring(playingStatus), 10, 70, 300);
  love.graphics.printf("difference            : " .. difference, 10, 85, 300);
  love.graphics.printf("pitch                 : " .. pitch, 10, 100, 300);
  love.graphics.printf("beat                  : " .. beat, 10, 115, 300);
  love.graphics.printf("measure               : " .. measure, 10, 130, 300);
  love.graphics.printf("measure dv            : " .. beatDV, 10, 145, 300);
  love.graphics.printf("calc time offset      : " .. offset, 10, 160, 300);
  love.graphics.draw(icon, 100, 250, calculatedSeconds/(1/6.28), 0.5, 0.5, 100, 100);
  
  if(beatDV == 1) then
    love.graphics.setColor(0.8, 0.3, 1);
  else
    love.graphics.setColor(1, 1, 1);
  end
  love.graphics.rectangle("fill", 10, 400, 25, 25);
  
  if(beatDV == 2) then
    love.graphics.setColor(0, 0.3, 1);
  else
    love.graphics.setColor(1, 1, 1);
  end
  love.graphics.rectangle("fill", 40, 400, 25, 25);
  
  if(beatDV == 3) then
    love.graphics.setColor(0, 0.3, 1);
  else
    love.graphics.setColor(1, 1, 1);
  end
  love.graphics.rectangle("fill", 70, 400, 25, 25);
  
  if(beatDV == 4) then
    love.graphics.setColor(0, 0.3, 1);
  else
    love.graphics.setColor(1, 1, 1);
  end
  love.graphics.rectangle("fill", 100, 400, 25, 25);
  
  love.graphics.setColor(1, 1, 1);
end