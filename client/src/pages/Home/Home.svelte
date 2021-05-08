<script>
  import {query} from 'svelte-apollo';
  import {gql} from '@apollo/client';

  import {Button} from '../../components';
  import {IMAGES_LISTED} from '../../data';

  const images = query(IMAGES_LISTED, {
    variables: {page: 1, limit: 24}
  });
</script>

<h1>Home</h1>
<Button label="Create" />

<ul>
  {#if $images.loading}
    <li>Loading...</li>
  {:else if $images.error}
    <li>ERROR: {$images.error.message}</li>
  {:else}
    {#each $images.data.imageListed.collection as image (image.id)}
      <li>{image.title}</li>
    {/each}
  {/if}
</ul>
