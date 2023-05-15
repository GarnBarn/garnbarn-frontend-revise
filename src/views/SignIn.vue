<template>
  <div class="signInBox">
    <md-card class="signInCard">
      <md-card-media-actions>
        <md-card-media>
          <img src="@/assets/images/garnbarn-logo.png" class="garnbarnLogo" />
        </md-card-media>

        <md-card-actions>
          <h3>Sign in to GarnBarn</h3>
          <div>
            <form @submit.prevent="login">
              <div class="auth">
                <div>
                  <label for="username">Email:</label>
                  <input id="username" v-model="email" type="text" />
                </div>
                <div class="password">
                  <label for="password">Password:</label>
                  <input id="password" v-model="password" type="password" />
                </div>
              </div>
              <div class="register-link">
                <div>
                  Don't have an account?<router-link to="/register">Register</router-link>
                </div>
              </div>
              <div class="forget-password">
                <router-link to="/forgot-password">Forgot your password?</router-link>
              </div>
              <div>
                <button type="submit">Login</button>
              </div>
            </form>
          </div>
          <div class="or">
            <p>or</p>
          </div>
          <div>
            <md-button class="md-dense md-raised" @click="oidcLogin">Signin with OIDC Provider</md-button>
          </div>
          <section id="firebaseui-auth-container"></section>
        </md-card-actions>
      </md-card-media-actions>
    </md-card>
  </div>
</template>

<script lang="ts">
import firebase from "firebase/app";
import * as firebaseUi from "firebaseui";
import "firebaseui/dist/firebaseui.css";
import { Component, Vue } from "vue-property-decorator";
import GarnBarnApiConfig from "@/GarnBarnApiConfig.json";

@Component
export default class SignIn extends Vue {
  email = "";
  password = "";

  mounted(): void {
    let firebaseAuthInstance: firebase.auth.Auth = firebase.auth();
    let uiConfig: any = {
      signInSuccessUrl: "/consent",
      signInOptions: [firebase.auth.GoogleAuthProvider.PROVIDER_ID],
      signInFlow: "popup",
    };
    let ui = new firebaseUi.auth.AuthUI(firebaseAuthInstance);
    ui.start("#firebaseui-auth-container", uiConfig);

    // firebase
    //   .auth()
    //   .getRedirectResult()
    //   .then((result) => {
    //     // IdP data available in result.additionalUserInfo.profile.
    //     // ...

    //     console.log(result);
    //     /** @type {firebase.auth.OAuthCredential} */
    //     var credential = result.credential;

    //     // // OAuth access and id tokens can also be retrieved:
    //     // var accessToken = credential?.accessToken;
    //     // var idToken = credential?.idToken;

    //     console.log(result.credential?.toJSON());
    //   })
    //   .catch((error) => {
    //     // Handle error.
    //   });
  }

  login(): void {
    firebase
      .auth()
      .signInWithEmailAndPassword(this.email, this.password)
      .then(() => {
        this.$router.push("/consent");
      })
      .catch((error) => {
        alert(error.message);
      });
  }

  parseJwt(token: string): any {
    try {
      return JSON.parse(Buffer.from(token, "base64").toString());
    } catch (e) {
      return null;
    }
  }

  generateRandomString() {
    const characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    let result = "";

    for (let i = 0; i < 10; i++) {
      const randomIndex = Math.floor(Math.random() * characters.length);
      result += characters.charAt(randomIndex);
    }

    return result;
  }


  createAuth0URL() {
    const data = {
      "response_type": "code",
      "client_id": GarnBarnApiConfig.client_id,
      "scope": "garnbarn",
      "nouce": this.generateRandomString(),
      "redirect_uri": `${window.location.origin}/access-token`,
      "audience": "https://api.garnbarn.sirateek.dev"
    }
    localStorage.setItem("redirect_uri", data.redirect_uri);
    localStorage.setItem("nouce", data.nouce);
    const prefix = "https://garnbarn.jp.auth0.com/authorize";
    const queryString = Object.entries(data)
      .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      .join("&");

    const url = `${prefix}?${queryString}`;

    return url;
  }


  oidcLogin(): void {
    alert(this.createAuth0URL())
    window.location.href = this.createAuth0URL();
    // firebase
    //   .auth()
    //   .signInWithPopup(provider)
    //   .then((result) => {
    //     const oauthAccessToken = (result.credential?.toJSON() as any)
    //       .oauthAccessToken;

    //     console.log(oauthAccessToken);

    //     if (!oauthAccessToken) {
    //       alert("Signin error");
    //       return;
    //     }

    //     const parsedJwt = this.parseJwt(oauthAccessToken);

    //     console.log(parsedJwt);

    //     console.log(parsedJwt.scope);
    //     this.$router.push("/consent");
    //   })
    //   .catch((error) => {
    //     alert(error.message);
    //   });
  }
}
</script>

<style scoped>
.signInBox {
  padding-top: 5%;
  padding-top: 5%;
}

.signInCard {
  padding: 10px;
  padding-top: 15px;
  border-radius: 20px;
  background-color: #f9f9f9;
  display: inline-block;
  vertical-align: top;
  overflow: auto;
  border: 1px solid rgba(#000, 0.12);
}

.garnbarnLogo {
  width: 150px;
  height: auto;
}

hr.rounded {
  margin-top: 5%;
  margin-bottom: 5%;
  margin-left: 10%;
  margin-right: 10%;
  border-top: 2px solid #bbb;
  border-radius: 5px;
}

.forget-password {
  text-align: right;
  margin-bottom: 0.25rem;
}

.password {
  margin: 0.25rem;
}

p {
  margin-block-start: 1rem;
  margin-block-end: 0em;
}

.or {
  font-size: 1.5rem;
  font-weight: 500;
}
</style>
