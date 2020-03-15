function love.load()
  audioExample = love.audio.newSource("ok.wav", "static");
  
  audioExample:play();
  pitch = 1.0;
  bpm = 60 / 128;
  beat = 0;
  beatDV = 0;
  measure = 0;
  time = 0;
  tick = 0;
  offset = 0.6;
  
  samples = audioExample:tell("samples");
  seconds = audioExample:tell("seconds");
  
  playingStatus = audioExample:isPlaying();
  lerpSeconds = 0;
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
  
  lerpSeconds = refloat(lerp(lerpSeconds, seconds, 15, dt), 3);
  
  difference = refloat(time - seconds, 3);
  
  beat = math.floor(lerpSeconds / bpm);
  beatDV = (beat % 4) + 1;
  
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
  end
end

function love.draw()
  love.graphics.printf("realtime              : " .. time, 10, 10, 300);
  love.graphics.printf("current audio samples : " .. samples, 10, 25, 300);
  love.graphics.printf("current audio time    : " .. seconds, 10, 40, 300);
  love.graphics.printf("current lerp time     : " .. lerpSeconds, 10, 55, 300);
  love.graphics.printf("current audio state   : " .. tostring(playingStatus), 10, 70, 300);
  love.graphics.printf("difference            : " .. difference, 10, 85, 300);
  love.graphics.printf("pitch                 : " .. pitch, 10, 100, 300);
  love.graphics.printf("beat                  : " .. beat, 10, 115, 300);
  love.graphics.printf("measure               : " .. measure, 10, 130, 300);
  love.graphics.printf("measure dv            : " .. beatDV, 10, 145, 300);
  love.graphics.draw(icon, 100, 250, lerpSeconds/(1/6.28), 1, 1, 100, 100);
  
  if(beatDV == 1) then
    love.graphics.setColor(0.5, 0.3, 1);
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