<template>
  <div class="content">
    <div class="leftItem"><slot name="left"></slot></div>
    <div class="title" v-text="title"></div>
    <div class="rightItem"><slot name="right"></slot></div>
  </div>
</template>

<script type="text/ecmascript-6">
  export default {
    props:[
      'title',
      'fixed'
    ]
  }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
  .content
    position: fixed
    width:100%
    margin-left: 0
    margin-top: 0
    height: 64px
    background-color: white
    .leftItem
      float: left
      margin-top: 20px
      margin-left: 0
      width: 60px
      height: 44px
      line-height: 44px
      a
        display: block
        text-decoration: none
        color: #333
        font-size: 16px
        img
          padding: 10px 10px
          width: 24px
          height: 24px
    .title
      display: inline-block;
      width: 180px
      height: 44px
      margin: 20px auto 0
      line-height: 44px
      font-size: 17px
      color: #333
    .rightItem
      float: right;
      margin-top: 20px
      margin-right: 0
      height: 44px
      width: 60px
      line-height: 44px
      a
        display: block
        text-decoration: none
        color: #333
        font-size: 16px
        img
          padding: 9px 8px
          width: 24px
          height: 24px
</style>
