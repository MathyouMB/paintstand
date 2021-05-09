import {gql} from '@apollo/client';

const UPLOAD_CANVAS = gql`
  mutation uploadCanvas(
    $title: String!
    $description: String!
    $dataUri: String!
    $price: Int!
  ) {
    uploadCanvas(
      title: $title
      description: $description
      dataUri: $dataUri
      price: $price
    ) {
      attachedImageUrl
      description
      id
      title
      price
    }
  }
`;

export {UPLOAD_CANVAS};
