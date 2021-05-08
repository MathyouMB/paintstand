user1 = User.create(
    username: "MathyouMB",
    email: "matt@email.com",
    password: "1234",
    balance: 10000,
    role: "admin"
  )

user2 = User.create(
  username: "MathyouMB2",
  email: "matt2@email.com",
  password: "1234",
  balance: 10000,
  role: "public"
)

image1 = Image.create!(
  title: "Day on the Ocean",
  description: "A paiting of a boat on the ocean.",
  creator_id: user1.id,
  owner_id: user2.id,
  price: 10,
  state: "listed"
)

image1.attached_image.attach(io: File.open("assets/1.png"), filename: "1.png")

image2 = Image.create!(
  title: "Rabbit with Carrot",
  description: "A paiting of a Rabbit and a Carrot.",
  creator_id: user2.id,
  owner_id: user1.id,
  price: 10,
  state: "listed"
)

image2.attached_image.attach(io: File.open("assets/2.png"), filename: "2.png")

image3 = Image.create!(
  title: "Nemo",
  description: "A paiting of some orange fish.",
  creator_id: user1.id,
  owner_id: user2.id,
  price: 10,
  state: "listed"
)

image3.attached_image.attach(io: File.open("assets/3.png"), filename: "3.png")

image4 = Image.create!(
  title: "Pizza",
  description: "A paiting of a pizza slice.",
  creator_id: user2.id,
  owner_id: user1.id,
  price: 10,
  state: "listed"
)

image4.attached_image.attach(io: File.open("assets/4.png"), filename: "4.png")

image5 = Image.create!(
  title: "Rose",
  description: "A paiting of a rose.",
  creator_id: user1.id,
  owner_id: user2.id,
  price: 10,
  state: "listed"
)

image5.attached_image.attach(io: File.open("assets/5.png"), filename: "5.png")

image6 = Image.create!(
  title: "Over the Hill",
  description: "A paiting of a hill side.",
  creator_id: user2.id,
  owner_id: user1.id,
  price: 10,
  state: "listed"
)

image6.attached_image.attach(io: File.open("assets/6.png"), filename: "6.png")

image7 = Image.create!(
  title: "Flower Man",
  description: "A guy with some a flower",
  creator_id: user1.id,
  owner_id: user2.id,
  price: 10,
  state: "listed"
)

image7.attached_image.attach(io: File.open("assets/7.png"), filename: "7.png")

image8 = Image.create!(
  title: "Sunglasses",
  description: "A guy with some sunglasses",
  creator_id: user2.id,
  owner_id: user1.id,
  price: 10,
  state: "listed"
)

image8.attached_image.attach(io: File.open("assets/8.png"), filename: "8.png")

image9 = Image.create!(
  title: "Ladybug",
  description: "A ladybug.",
  creator_id: user1.id,
  owner_id: user2.id,
  price: 10,
  state: "listed"
)

image9.attached_image.attach(io: File.open("assets/9.png"), filename: "9.png")

image10 = Image.create!(
  title: "Car",
  description: "A poorly drawn car.",
  creator_id: user2.id,
  owner_id: user1.id,
  price: 10,
  state: "listed"
)

image10.attached_image.attach(io: File.open("assets/10.png"), filename: "10.png")

# Tags

tag_outdoors = Tag.create(
  name: "Outdoors"
)

tag_object = Tag.create(
  name: "Object"
)

tag_animal = Tag.create(
  name: "Animal"
)

tag_people = Tag.create(
  name: "People"
)

# Image Tags

ImageTag.create(
  image_id: image1.id,
  tag_id: tag_outdoors.id
)

ImageTag.create(
  image_id: image1.id,
  tag_id: tag_animal.id
)

ImageTag.create(
  image_id: image2.id,
  tag_id: tag_object.id
)

ImageTag.create(
  image_id: image2.id,
  tag_id: tag_animal.id
)

ImageTag.create(
  image_id: image3.id,
  tag_id: tag_outdoors.id
)

ImageTag.create(
  image_id: image3.id,
  tag_id: tag_animal.id
)

ImageTag.create(
  image_id: image4.id,
  tag_id: tag_object.id
)

ImageTag.create(
  image_id: image5.id,
  tag_id: tag_object.id
)

ImageTag.create(
  image_id: image5.id,
  tag_id: tag_outdoors.id
)

ImageTag.create(
  image_id: image6.id,
  tag_id: tag_outdoors.id
)

ImageTag.create(
  image_id: image7.id,
  tag_id: tag_people.id
)

ImageTag.create(
  image_id: image8.id,
  tag_id: tag_people.id
)

ImageTag.create(
  image_id: image9.id,
  tag_id: tag_animal.id
)

ImageTag.create(
  image_id: image10.id,
  tag_id: tag_object.id
)
