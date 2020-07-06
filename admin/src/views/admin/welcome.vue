<template>
    <div>
        <h1>Hello,Welcome!</h1>
    </div>
</template>

<script>
    export default {
        name: "welcome",
        mounted(){
            this.$parent.activeSideBar("welcome-sidebar");
        }
    }
</script>

<style scoped>

</style>