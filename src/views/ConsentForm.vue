<template>
  <layout :callback="callback">
    <div class="consentForm">
      <h2>Consent Form</h2>
      <div class="consentText">
        <pre>{{ consent.detail }}</pre>
      </div>
      <div>
        <div class="consentCheckbox">
          <label for="consent">
            <input id="consent" type="checkbox" v-model="consentChecked" />
            I agree to the terms and conditions
          </label>
        </div>
        <div class="submitButton">
          <button :disabled="!consentChecked" @click="submitForm">
            Submit
          </button>
        </div>
      </div>
    </div>
  </layout>
</template>

<script lang="ts">
  import { Vue, Component } from "vue-property-decorator";
  import DialogBox from "@/components/DialogBox/DialogBox";
  import GarnBarnApi from "@/services/GarnBarnApi/GarnBarnApi";
  import firebase from "firebase/app";
  import Layout from "@/layouts/Main.vue";

  @Component({
    components: {
      Layout,
    },
  })
  export default class SignIn extends Vue {
    user: firebase.User | null = null;
    consentChecked = false;
    garnBarnAPICaller: GarnBarnApi | null = null;
    firebaseUser: firebase.User | null = null;

    async callback(
      user: firebase.User,
      loadingDialogBox: DialogBox
    ): Promise<void> {
      this.garnBarnAPICaller = new GarnBarnApi(user);
      this.firebaseUser = user;
      loadingDialogBox.dismiss();
      try {
        await this.garnBarnAPICaller.v1.tags.all();
        this.$router.push("/home");
      } catch (error) {
        return;
      }
    }

    consent = {
      detail: `
Term and Conditions / Privacy Policy
Last updated: May 13, 2023
Welcome to the Assignment Tracking Application ("Application"). Please read these Terms and Conditions
("Terms", "Terms and Conditions") and Privacy Policy carefully before using the Application, as they govern
your access to and use of the Application. By accessing or using the Application, you agree to be bound by
these Terms and Conditions and the Privacy Policy. If you disagree with any part of these terms, you must not use the Application.
1.  Definitions
    - "Application" refers to the Assignment Tracking Application.
    - "User", "You", or "Your" refers to the individual using the Application.
    - "We", "Us", "Our", or "Provider" refers to the creator and owner of the Assignment Tracking Application.
2.  License
3.  We grant you a limited, non-exclusive, non-transferable, and revocable license to use the Application for
    your personal, non-commercial purposes. You agree not to reproduce, duplicate, copy, sell, resell, or
    exploit any portion of the Application without our express written permission.
4.  User Accounts
5.  To access certain features of the Application, you may be required to create a user account. You are
    responsible for maintaining the confidentiality of your account information, including your password, and
    for all activities that occur under your account. You agree to notify us immediately of any unauthorized use
    of your account.
6.  User Content
7.  You are solely responsible for any content you submit, post, or transmit through the Application, including,
    but not limited to, assignment details, notes, and other information. You agree not to submit any content
    that is unlawful, harmful, threatening, abusive, harassing, defamatory, or otherwise objectionable.
8.  Privacy Policy
9.  Your privacy is important to us. Please review our Privacy Policy, which governs the collection, use, and
    disclosure of your personal information when using the Application. By using the Application, you consent to
    the collection and use of your personal information as described in the Privacy Policy.
10. Intellectual Property
11. The Application and its original content, features, and functionality are owned by the Provider and are
    protected by international copyright, trademark, patent, trade secret, and other intellectual property or
    proprietary rights laws.
12. Termination
13. We reserve the right to terminate your access to the Application, without cause or notice, for any reason,
    including but not limited to a breach of these Terms. Upon termination, your right to use the Application
    will immediately cease.
14. Changes to Terms and Conditions
15. We reserve the right to modify or replace these Terms and Conditions at any time. If a revision is material,
    we will make reasonable efforts to provide at least 30 days' notice before any new terms take effect. What
    constitutes a material change will be determined at our sole discretion.
16. Governing Law
17. These Terms and Conditions shall be governed by and construed in accordance with the laws of the
    jurisdiction in which the Provider is based, without regard to its conflict of law provisions.
18. Contact Us
19. If you have any questions about these Terms and Conditions, please contact us.
Privacy Policy
    1. Information Collection
    2. We collect personal information when you create an account, including but not limited to your name, email
        address, and password. We may also collect usage data, including information about how you use the
        Application and interact with its features.
    3. Use of Information
    4. We use your personal information for various purposes, including to:
        - Provide, maintain, and improve the Application.
        - Notify you about changes to the Application or any products or services we offer or provide.
        - Respond to your inquiries and requests.
        - Detect, prevent, or address technical or security issues.
        - Protect the rights, property, or safety of us, our users, or others
        `,
    };

    async submitForm() {
      const response = await this.garnBarnAPICaller?.v1.accounts.updateConsent(
        this.consentChecked
      );
      this.$router.push("/home");
    }
  }
</script>

<style scoped>
  .consentForm {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }

  .consentCheckbox {
    height: 100%;
  }

  .submitButton {
    margin-top: 20px;
  }

  button[disabled] {
    cursor: not-allowed;
    opacity: 0.5;
  }

  .consentText {
    display: flex;
    text-align: start;
    justify-content: center;
    height: 100%;
    max-width: 100%;
  }
</style>
