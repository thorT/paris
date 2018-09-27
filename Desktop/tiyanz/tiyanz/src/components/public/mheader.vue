<template>
    <div>
        <div id="mheader" :style="{ background: bgColorArr[bgColor],color:titleColor}">
            <div class="statusBar"></div>
            <div class="content" :style="shadow?styleobj:''">
                <img src="../../assets/image/back_2.png" @click="back">
                {{title}}
                <router-link :to="subpath" class="subtitle" :style="{color:titleColor}" v-if="subtitle">
                    {{subtitle}}
                </router-link>
            </div>

        </div>
        <!--<div class="empty"></div>-->
    </div>
</template>

<script type="text/ecmascript-6">
    export default{
        props: {
            title: {
                type: String,
                required: true
            },
            bgColor: {
                type: String,
                default:'themeWhite'
            },
            titleColor: {
                type: String,
            },
            shadow:{
                type:Boolean
            },
            subtitle: {
                type: String,
            },
            subpath: {
                type: String,
            },
            topath: {
                type: String,
            }
        },
        data(){
            return {
                styleobj:{
                    'box-shadow': '0 2px 4px 0 rgba(103,103,103,0.14)'
                },
                bgColorArr: {
                    theme: ' linear-gradient(to right, #FD7049 , #FDA86A,#FDA990)',
                    themeWhite: '#409EFF',
                },

            }
        },
        methods: {
            back(){
              this.$router.go(-1)
//                this.topath ? this.$router.push(this.topath) : this.$router.back()
            }
        }
    }
</script>

<style scoped lang="stylus" rel="stylesheet/stylus">
    @import "~common/stylus/variable"
    #mheader
        position: relative
        width: 100%
        font-size: $font-size-medium-x
        z-index: 200
        font-weight: bold
        .statusBar
            height: $nav-blank
        .content
            height: $nav-height
            line-height: $nav-height
            text-align: center
            position relative
            color white
            img
                position: absolute
                top 10px
                left: 20px
                display: inline-block
                width: 100px
        .noshadow .content
            box-shadow: 0 2px 4px 0 rgba(103,103,103,0.14);

    .empty
        height: $nav;
        width: 100%;
        box-sizing: border-box;

    .subtitle
        display inline-block
        font-size $font-size-medium
        position fixed
        right 10px
        top: 20px

</style>
