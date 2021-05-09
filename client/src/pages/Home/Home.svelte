<script>
  import {query} from 'svelte-apollo';
  import Icon from 'fa-svelte';
  import {faSearch} from '@fortawesome/free-solid-svg-icons';
  import {link} from 'svelte-spa-router';

  import {ImagePreview} from '../../components';
  import {IMAGE_SEARCH} from '../../data';

  const queryString = window.location.search;
  const urlParams = new URLSearchParams(queryString);
  let search = urlParams.get('search') == null ? '' : urlParams.get('search');

  const searched_images = query(IMAGE_SEARCH, {
    variables: {searchInput: search, page: 0, limit: 24}
  });

  const handleKeyup = () => {
    if (event.code == 'Enter') {
      event.preventDefault();
      window.location.assign(
        window.location.protocol +
          '//' +
          window.location.host +
          '' +
          window.location.pathname +
          '?search=' +
          search
      );
      return false;
    }
  };
</script>

<div class="header">
  <div class="header-inner">
    <div class="header-text">
      <div class="header-text-title">Paint Stand</div>
      <div class="header-text-slogan">
        Create and sell your virtual paintings.
      </div>
    </div>
    <div class="search">
      <div class="search-icon"><Icon icon={faSearch} /></div>
      <input
        class="search-input"
        id="search"
        type="text"
        bind:value={search}
        on:keyup|preventDefault={handleKeyup}
      />
    </div>
  </div>
</div>
<div class="images-container">
  {#if $searched_images.loading}
    <div>Loading...</div>
  {:else if $searched_images.error}
    <div>ERROR: {$searched_images.error.message}</div>
  {:else}
    {#each $searched_images.data.imageSearch.collection as image (image.id)}
      <a href={'/image/' + image.id} use:link>
        <ImagePreview imgsrc={image.attachedImageUrl} />
      </a>
    {/each}
  {/if}
</div>

<style type="text/scss">
  @import 'Home.scss';
</style>
