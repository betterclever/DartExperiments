import 'dart:html';
import 'dart:math' as Math;

CanvasElement canvas;
CanvasRenderingContext2D ctx;

num curTime = 0;

Math.Random random = new Math.Random();

class Point {
  num x, y;
  num prevX, prevY;
  num _timePassed = 0;
  bool sideways = random.nextBool();
  num interval = random.nextDouble()*3 + 1;
  num velX = 0;
  num velY = 0;
  num width = random.nextInt(3) + 3;

  Point(this.x, this.y) {
    prevX = x;
    prevY = y;
    if (sideways) {
      velX = random.nextInt(100);
    }
    else {
      velY = random.nextInt(100);
    }
  }

  draw(var gradient) {
    ctx.beginPath();
    ctx.strokeStyle = gradient;
    ctx.lineWidth = width;
    ctx.moveTo(prevX,prevY);
    ctx.lineTo(x, y);
    ctx.closePath();
    ctx.lineCap = 'round';
    ctx.closePath();
    ctx.stroke();
  }

  update(var delta) {
    prevX = x;
    prevY = y;
    x += velX/10 ;
    y += velY/10 ;
    _timePassed += delta;
    if (_timePassed > interval) {
      _timePassed = 0;
      sideways = !sideways;
      velX = velY = 0;
      if (sideways) {
        velX = random.nextInt(200) - 100;
      }
      else {
        velY = random.nextInt(200) - 100;
      }
    }
    if (x > ctx.canvas.width || x < 0) {
      x = random.nextInt(1920);
      prevX = x;
    }
    if (y > ctx.canvas.height || y < 0) {
      y = random.nextInt(1080);
      prevY = y;
    }
  }
}

List<Point> points;

main() {
  canvas = querySelector('#canvas');
  ctx = canvas.getContext("2d");
  points = new List<Point>();

  ctx.canvas.width = window.innerWidth;
  ctx.canvas.height = window.innerHeight;
  for (var i = 0; i < 20; i++)
    points.add(new Point(random.nextInt(1920), random.nextInt(1080)));
  window.animationFrame.then(draw);
}

draw(num time) {
  var delta = 0.02;
  curTime += 0.02;

  if (curTime.toInt() % 10 == 0) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  }
  var gradient = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
  gradient.addColorStop(0, "#00c159");
  gradient.addColorStop(0.5, "#ff89ac");
  gradient.addColorStop(1.0, "#249fc1");

  for (Point p in points) {
    p.draw(gradient);
    p.update(delta);
  }
  window.animationFrame.then(draw);
}



