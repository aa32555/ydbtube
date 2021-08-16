<template>
  <div class="q-pa-md column inline flex flex-center" style="max-width: 400px">
<div class="col-8" style="padding-top:300px;">
    <q-form
      @submit="onSubmit"
      @reset="onReset"
      class="q-gutter-md"
      style="width:600px"
    >
      <q-input
        filled
        v-model="url"
        label="YouTube video URL "
        hint="YouTube Video URL"
        lazy-rules
        :rules="[ val => val && val.length > 0 || 'Please type something']"
      />

        <q-toggle v-model="accept" label="I accept the license and terms" />

      <div>
        <q-btn label="Upload" type="submit" color="primary"/>
      </div>
    </q-form>
</div>
<div class="col-4">
      <q-spinner-tail color="blue"  size="8.5em" v-if="showSpinner"/>
</div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      url:null,
      accept: false,
      showSpinner:false
    }
  },

  methods: {
    async onSubmit () {
      if (this.accept !== true) {
        this.$q.notify({
          color: 'red-5',
          textColor: 'white',
          icon: 'warning',
          message: 'You need to accept the license and terms first'
        })
        return
      }
       this.showSpinner=true
      await this.$M('UPLOAD^YDBTUBEAPI',{
          URL: this.url
      })
       this.showSpinner=false
    },

    onReset () {
      this.url = null
      this.accept = false
    }
  }
}
</script>
