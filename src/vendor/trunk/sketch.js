module.exports = ({ size, params, userSetup }) => {
  let sketch = function(p) {
    let ox = p.random(10000);
    let oy = p.random(10000);
    let oz = p.random(10000);

    p.setup = function(){
      p.createCanvas(800, 800);
      p.strokeWeight(1);
      p.stroke(255);
      p.smooth();
      p.noFill();
      userSetup.call(p)
    }

    p.draw = function() {
      p.clear();
      p.translate(p.width / 2, p.height / 2);
      display();
    }

    function display(){
      //ox+=0.04;
      oy-=0.02;
      oz+=0.01;
      for(let i = 0; i < params.rings; i ++){
      p.beginShape();
        for(let angle = 0; angle < 360; angle++){
          let radian = p.radians(angle);
          let radius =  (params.chaos_mag * getNoiseWithTime(radian, params.chaos_delta * i + params.chaos_init, oz)) + (params.dim_delta * i + params.dim_init);
          p.vertex(radius * p.cos(radian), radius * p.sin(radian));
        }
      p.endShape(p.CLOSE);
      }
    }

    function getNoise (radian, dim){
      let r = radian % p.TWO_PI;
      if(r < 0.0){r += p.TWO_PI;}
      return p.noise(ox + p.cos(r) * dim, oy + p.sin(r) * dim);
    }

    function getNoiseWithTime (radian, dim, time){
      let r = radian % p.TWO_PI;
      if(r < 0.0){r += p.TWO_PI;}
      return p.noise(ox + p.cos(r) * dim , oy + p.sin(r) * dim, oz + time);
    }
  }

  return new p5(sketch);
}