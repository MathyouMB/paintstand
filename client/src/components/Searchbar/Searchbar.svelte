<script>
  import Icon from 'fa-svelte';
  import {faSearch} from '@fortawesome/free-solid-svg-icons';
</script>

<div class="search">
  <div class="search-icon"><Icon icon={faSearch} /></div>
  <input class="search-input" value="" />
</div>

<style type="text/scss">
  @import 'Searchbar.scss';
</style>
