import {gql} from '@apollo/client';

const IMAGE_SEARCH = gql`
  query imageSearch($searchInput: String!, $page: Int!, $limit: Int!) {
    imageSearch(searchInput: $searchInput, page: $page, limit: $limit) {
      collection {
        attachedImageUrl
        description
        id
        price
        title
      }
    }
  }
`;

export {IMAGE_SEARCH};
