<script>
  import Router from 'svelte-spa-router';
  import {Home, Image, NotFound, Paint} from './pages';
  const routes = {
    '/': Home,
    '/image': Image,
    '/paint': Paint,
    '*': NotFound
  };
</script>

<Router {routes} />

<style type="text/scss">
  @import 'global.scss';
</style>
