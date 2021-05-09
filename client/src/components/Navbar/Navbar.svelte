<script>
  import {Button} from '../../components';
  import {link} from 'svelte-spa-router';
</script>

<div class="navbar">
  <div class="navbar-inner">
    <a href="/" use:link>
      <div class="logo">
        <img class="logo-image" src="/logo.png" alt="logo" />
      </div>
    </a>
    <a href="/paint" use:link>
      <Button label="Create" />
    </a>
  </div>
</div>

<style type="text/scss">
  @import 'Navbar.scss';
</style>
