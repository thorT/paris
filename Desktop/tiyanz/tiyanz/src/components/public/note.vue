<template>
  <div class="note">
    <p class="gray">{{title}}</p>
  </div>
</template>
<script>
  export default{
    props: {
      title: {
        type: String,
        required: true
      }
    },
    data(){
      return {
      }
    },


  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  @import "~common/stylus/variable"
  .note
    position relative
    width 100%
    text-align center !important
    p
      font-size $font-size-medium-x
      line-height 30px
      margin-top 400px
</style>
