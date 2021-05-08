import {gql} from '@apollo/client';

const IMAGE = gql`
  query image($id: ID!) {
    image(id: $id) {
      attachedImageUrl
      creator {
        username
      }
      description
      id
      owner {
        username
      }
      price
      title
    }
  }
`;

export {IMAGE};
