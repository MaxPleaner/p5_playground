var Draggable;

module.exports = Draggable = class Draggable {
  constructor(x, y, w, h) {
    this.dragging = false; // Is the object being dragged?
    this.rollover = false; // Is the mouse over the ellipse?
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.offsetX = 0;
    this.offsetY = 0;
  }

  over(p5) {
    // Is mouse over object
    if (p5.mouseX > this.x && p5.mouseX < this.x + this.w && p5.mouseY > this.y && p5.mouseY < this.y + this.h) {
      return this.rollover = true;
    } else {
      return this.rollover = false;
    }
  }

  update(p5) {
    // Adjust location if being dragged
    if (this.dragging) {
      this.x = p5.mouseX + this.offsetX;
      return this.y = p5.mouseY + this.offsetY;
    }
  }

  show(p5) {
    p5.stroke(0);
    // Different fill based on state
    if (this.dragging) {
      p5.fill(50);
    } else if (this.rollover) {
      p5.fill(100);
    } else {
      p5.fill(175, 200);
    }
    return p5.rect(this.x, this.y, this.w, this.h);
  }

  pressed(p5) {
    // Did I click on the rectangle?
    if (p5.mouseX > this.x && p5.mouseX < this.x + this.w && p5.mouseY > this.y && p5.mouseY < this.y + this.h) {
      this.dragging = true;
      // If so, keep track of relative location of click to corner of rectangle
      this.offsetX = this.x - p5.mouseX;
      return this.offsetY = this.y - p5.mouseY;
    }
  }

  released() {
    // Quit dragging
    return this.dragging = false;
  }

};
