let c, ctx, x, y, prevX, prevY, currX, currY, isDrawing, width = 10, height = 10;

function drawMain() {
  c = document.querySelector("#annotate");
  ctx = c.getContext("2d");
  var ratio = window.devicePixelRatio ? window.devicePixelRatio : 1;
  // original is 480 x 270
  c.width = 480 * ratio;
  c.height = 270 * ratio;

  x = c.width / 2;
  y = c.height / 2;

  c.addEventListener("mousemove", (e) => {findxy('move', e)}, false);
  c.addEventListener("mousedown", (e) => {findxy('down', e)}, false);
  c.addEventListener("mouseup",   (e) => {findxy('up', e)}, false);
  render_draw();
}

function findxy(res, e) {
  if (res == 'down') {
      prevX = currX;
      prevY = currY;
      currX = e.clientX - c.offsetLeft;
      currY = e.clientY - c.offsetTop;

      isDrawing = true;
      ctx.beginPath();
      ctx.fillStyle = 'red';
      ctx.fillRect(currX, currY, 2, 2);
      ctx.closePath();
  }
  if (res == 'up') {
    isDrawing = false;
  }
  if (res == 'move' && isDrawing) {
    prevX = currX;
    prevY = currY;
    currX = e.clientX - c.offsetLeft;
    currY = e.clientY - c.offsetTop;
    render_draw();
  }
}

function render_draw() {
  ctx.beginPath();
  ctx.moveTo(prevX, prevY);
  ctx.lineTo(currX, currY);
  ctx.strokeStyle = 'red';
  ctx.lineWidth = 5;
  ctx.stroke();
  ctx.closePath();
}

function clearCanvas() {
  ctx.clearRect(0, 0, c.width, c.height);
}

drawMain();