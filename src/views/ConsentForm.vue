<template>
    <div class="consentForm">
        <h2>Consent Form</h2>
        <md-table>
            <md-table-row v-for="(consent, index) in consents" :key="index">
                <md-table-cell>{{ consent.detail }}</md-table-cell>
                <md-table-cell>
                    <md-checkbox v-model="consent.checked" @input="validateForm" />
                </md-table-cell>
            </md-table-row>
        </md-table>
        <div class="submitButton">
            <button :disabled="!isValidForm" @click="submitForm">Submit</button>
        </div>
    </div>
</template>
  
<script>
import { Vue, Component } from 'vue-property-decorator';

@Component
export default class SignIn extends Vue {
    consents = [
        { detail: 'Consent 1', checked: false },
        { detail: 'Consent 2', checked: false },
        { detail: 'Consent 3', checked: false },
    ];

    get isValidForm() {
        return this.consents.every(consent => consent.checked);
    }

    submitForm() {
        if (!this.isValidForm) {
            alert('Please accept all consents to proceed.');
            return;
        }
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

.submitButton {
    margin-top: 20px;
}

button[disabled] {
    cursor: not-allowed;
    opacity: 0.5;
}
</style>
  