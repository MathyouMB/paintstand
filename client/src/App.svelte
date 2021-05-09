<script>
  import Router from 'svelte-spa-router';
  import {ApolloClient, InMemoryCache} from '@apollo/client';
  import {createHttpLink} from 'apollo-link-http';
  import {setClient} from 'svelte-apollo';

  import {Footer, Navbar} from './components';
  import {Home, Image, NotFound, Paint} from './pages';

  const routes = {
    '/': Home,
    '/image/:id': Image,
    '/paint': Paint,
    '*': NotFound
  };

  const httpLink = createHttpLink({
    uri: 'http://localhost:3000/graphql',
    headers: {
      'Content-Type': 'application/json',
      Authentication:
        'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6Mn0.EWcKepSTEm3T0zCyisld8FkytXpLSQ094WWZy-Fiqr4'
    }
  });

  const client = new ApolloClient({
    link: httpLink,
    cache: new InMemoryCache()
  });

  setClient(client);
</script>

<Navbar />
<Router {routes} />
<Footer />

<style type="text/scss">
  @import 'global.scss';
</style>
