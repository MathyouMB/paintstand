<script>
  import {query} from 'svelte-apollo';
  import {gql} from '@apollo/client';
  import Icon from 'fa-svelte';
  import {faSearch} from '@fortawesome/free-solid-svg-icons';

  import {Button, ImagePreview} from '../../components';
  import {IMAGE} from '../../data';

  export let params = {};

  const image = query(IMAGE, {
    variables: {id: params.id}
  });
</script>

<div class="image-container">
  {#if $image.loading}
    <div>Loading...</div>
  {:else if $image.error}
    <div>ERROR: {$image.error.message}</div>
  {:else}
    <div class="image-split">
      <img src={'http://localhost:3000' + $image.data.image.attachedImageUrl} />
      <div class="image-info">
        <div class="title">{$image.data.image.title}</div>
        <div class="username">{$image.data.image.owner.username}</div>
        <div class="price">${$image.data.image.price}.00</div>
        <div class="description">{$image.data.image.description}</div>
        <Button label="Purchase" />
      </div>
    </div>
  {/if}
</div>

<style type="text/scss">
  @import 'Image.scss';
</style>
