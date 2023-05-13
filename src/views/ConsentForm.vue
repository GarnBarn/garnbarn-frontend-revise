<template>
    <div class="consentForm">
        <h2>Consent Form</h2>
        <div class="consentText">
            <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor
                aliquam leo, id efficitur dui. Nulla fringilla neque vel metus
                ullamcorper consequat. Suspendisse eu convallis elit. Morbi vestibulum
                lacus sit amet nulla iaculis, et vestibulum elit faucibus. In fermentum
                sapien a nibh interdum, eu consequat metus aliquam. Aenean posuere sit
                amet lectus ut luctus. Fusce in varius ex.
            </p>
        </div>
        <div class="consentCheckbox">
            <label for="consent">
                <input id="consent" type="checkbox" v-model="consentChecked" />
                I agree to the terms and conditions
            </label>
        </div>
        <div class="submitButton">
            <button :disabled="!consentChecked" @click="submitForm">Submit</button>
        </div>
    </div>
</template>

<script lang="ts">
import { Vue, Component } from 'vue-property-decorator';


@Component
export default class SignIn extends Vue {
    consentChecked = false;
    submitForm() {
        // Perform form submission logic here
        alert('Form submitted!');
    }
}
</script>

<style scoped>
.consentForm {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
}

.consentCheckbox {
    margin-top: 10px;
}

.submitButton {
    margin-top: 20px;
}

button[disabled] {
    cursor: not-allowed;
    opacity: 0.5;
}
</style>