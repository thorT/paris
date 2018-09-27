<template>
    <div class="mbutton">
        <a :style="{ background: bgColor,color:titleColor}" @click="aclick">{{title}}</a>
    </div>
</template>

<script type="text/ecmascript-6">
    export default {
        props:{
            title: {
                type: String,
            },
            titleColor:{
                type: String,
                default: 'white'
            },
            bgColor:{
                type: String,
                default: '#409EFF'
            }
        },
        methods:{
            aclick(){
                this.$emit('buttonAction')
            }
        }
    }
</script>


<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    .mbutton
        a
            display block
            width 90%
            height  $button-height
            text-align center
            line-height $button-height
            color $color-theme
            margin 0px auto
            border-radius 45px
            font-size $font-size-medium-x

</style>
