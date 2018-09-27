<template>
    <div class="norecord">
        <img v-lazy="imgInit">
        <p class="gray">{{title}}</p>
        <a>{{btitle}}</a>
    </div>
</template>
<script>
    export default{
        props: {
            imgSrc: {
                type: String,
                required: true
            },
            title: {
                type: String,
                required: true
            },
            btitle: {
                type: String,
            }
        },
        data(){
            return {
                imgInit: require('@/assets/image/empty/'+this.imgSrc)
            }
        },


    }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    .norecord
       img
        width 60%
        margin 100px auto 10px
       p
        font-size $font-size-medium-x
        line-height 30px
       a
         display inline-block
         height  45px
         line-height  45px
         width   150px
         border: 1px solid #C9C9C9;
         border-radius: 49px;
         color: #FD7049;
         letter-spacing: -0.11px;
         margin 45px auto
</style>