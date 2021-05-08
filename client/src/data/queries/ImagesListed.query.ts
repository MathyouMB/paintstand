import {gql} from '@apollo/client';

const IMAGES_LISTED = gql`
  query imageListed($page: Int!, $limit: Int!) {
    imageListed(page: $page, limit: $limit) {
      collection {
        attachedImageUrl
        description
        id
        price
        title
      }
      metadata {
        currentPage
        limitValue
        totalCount
        totalPages
      }
    }
  }
`;

export {IMAGES_LISTED};
