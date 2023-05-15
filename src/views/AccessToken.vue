<template>
    <p></p>
</template>
  
<script lang="ts">
import { Vue, Component } from "vue-property-decorator";
import axios from 'axios';
import firebase from "firebase/app";
import Layout from "@/layouts/Main.vue";
import GarnBarnApiConfig from "@/GarnBarnApiConfig.json";

@Component({
    components: {
        Layout,
    },
})
export default class accessToken extends Vue {
    firebaseUser: firebase.User | null = null;

    mounted() {
        this.executeCode();
    }

    async executeCode() {
        const queryData = this.getUrlParams(window.location.href);
        const redirect_uri = localStorage.getItem("redirect_uri")
        const nonce = localStorage.getItem("nonce")
        const scope = localStorage.getItem("scope")
        const body = {
            code: queryData.code,
            redirect_uri: redirect_uri,
            nonce: nonce,
            scope: scope
        };
        try {
            const response: any = await axios.post(`${GarnBarnApiConfig.apiPrefix}/api/v1/account/token`, body);
            await firebase.auth().signInWithCustomToken(response.data.token)
            this.$router.push("/consent")
        } catch (error) {
            alert("You are not authorized to use garnbarn. Please contract adminitrator.")
            this.$router.push("/signin");
        }
    }

    getUrlParams(url: string) {
        const params: { [key: string]: string } = {};
        const urlParts = url.split("?");

        if (urlParts.length > 1) {
            const queryString = urlParts[1];
            const paramPairs = queryString.split("&");

            for (const pair of paramPairs) {
                const [key, value] = pair.split("=");
                const decodedKey = decodeURIComponent(key);
                const decodedValue = decodeURIComponent(value);
                params[decodedKey] = decodedValue;
            }
        }
        return params;
    }
}
</script>
  