<script>
  import {Meta, Template, Story} from '@storybook/addon-svelte-csf';
  import ImagePreview from './ImagePreview.svelte';
</script>

<Meta
  title="Example/ImagePreview"
  component={ImagePreview}
  argTypes={{
    imgsrc: {control: 'test'}
  }}
/>

<Template let:args>
  <ImagePreview {...args} />
</Template>

<Story
  name="Base"
  args={{
    imgsrc: 'test'
  }}
/>
