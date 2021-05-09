<script>
  import {HsvPicker} from 'svelte-color-picker';
  import {mutation} from 'svelte-apollo';

  import {UPLOAD_CANVAS} from '../../data';
  import {Button} from '../../components';

  const uploadCanvas = mutation(UPLOAD_CANVAS);

  let canvas;
  let pen = 'up';
  let mode = 'draw';
  let lineWidth = 3;
  let penColor = 'black';
  let penCoords = [0, 0];

  let title = '';
  let description = '';
  let price = 0;

  async function upload() {
    let dataUri = canvas.toDataURL('image/png');
    try {
      await uploadCanvas({variables: {title, description, price, dataUri}});
    } catch (error) {
      console.log(error);
    }
  }

  const draw = () => {
    mode = 'draw';
  };

  const erase = () => {
    mode = 'erase';
  };

  const drawing = (e, ctx) => {
    if (pen === 'down') {
      ctx.beginPath();
      ctx.lineWidth = lineWidth;
      ctx.lineCap = 'round';

      if (mode === 'draw') {
        ctx.strokeStyle = penColor;
      }

      if (mode === 'erase') {
        ctx.strokeStyle = '#ffffff';
      }

      ctx.moveTo(penCoords[0], penCoords[1]);
      ctx.lineTo(e.offsetX, e.offsetY);
      ctx.stroke();

      penCoords = [e.offsetX, e.offsetY];
    }
  };

  const penDown = e => {
    pen = 'down';
    penCoords = [e.offsetX, e.offsetY];
  };

  const penUp = () => {
    pen = 'up';
  };

  const colorChange = rgba => {
    penColor =
      'rgb(' + rgba.detail.r + ',' + rgba.detail.g + ',' + rgba.detail.b + ')';
  };

  const penSizeUp = () => {
    lineWidth = lineWidth <= 100 ? lineWidth + 10 : 100;
  };

  const penSizeDown = () => {
    lineWidth = lineWidth > 1 ? lineWidth - 10 : 1;
  };

  const reset = () => {
    mode = 'draw';
    pen = 'up';
    lineWidth = 3;
    penColor = 'black';

    let ctx = canvas.getContext('2d');
    ctx.fillStyle = 'white';
    ctx.fillRect(0, 0, 800, 600);
    ctx.lineWidth = 10;
  };
</script>

<div class="draw-page">
  <div class="draw-page-inner">
    <div class="left">
      <canvas
        bind:this={canvas}
        width={800}
        height={600}
        on:mousemove={e => drawing(e, canvas.getContext('2d'))}
        on:mousedown={penDown}
        on:mouseup={penUp}
      />

      <div class="buttons">
        <Button label="+" on:click={penSizeUp} />
        <Button label="-" on:click={penSizeDown} />
        <Button label="reset" on:click={reset} />
      </div>
    </div>
    <div class="right">
      <div class="save">
        <input class="paint-input" placeholder="title" bind:value={title} />
        <input
          class="paint-input"
          placeholder="description"
          bind:value={description}
        />
        <input
          class="paint-input"
          id="last"
          placeholder="price"
          bind:value={price}
        />
        <Button label="Save" on:click={upload} />
      </div>
      <HsvPicker on:colorChange={colorChange} startColor={'#000000'} />
    </div>
  </div>
</div>

<style>
  .draw-page {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
  }

  .draw-page-inner {
    display: flex;
  }

  .left {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .right {
    margin-left: 3rem;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    height: 63vh;
  }

  .save {
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
  }

  input {
    font-size: 16px;
    width: 100%;
    border: none;
    outline: none;
  }

  #last {
    margin-bottom: 2rem;
  }

  .buttons {
    display: flex;
    margin-top: 5rem;
    width: 60%;
    justify-content: space-evenly;
  }

  .lower {
    display: flex;
    justify-content: center;
  }
  canvas {
    box-shadow: 0px 0px 3px 0px rgba(0, 0, 0, 0.25);
  }
</style>
