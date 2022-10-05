# Update SAML2 Certificate

The OpenSSL certificate used by Laddr's Single Sign-On (SSO) integration with Slack needs to be refreshed occasionally when it nears or passes its expiration date

## Generate a new certificate

On any computer with the `openssl` command installed (readily available on macOS and Linux), you can generate the new key+certificate pair before installing it to your Slack and Laddr instances:

1. Generate private key:

    ```bash
    openssl genrsa \
        -out ./laddr-slack-private-key.pem \
        1024
    ```

2. Generate public certificate:

    ```bash
    openssl req -new -x509 \
        -days 1095 \
        -key ./laddr-slack-private-key.pem \
        -out ./laddr-slack-public-cert.pem
    ```

    *Fill out the prompts with appropriate information about your organization. These values don't really matter for anything*

3. If your Laddr instance is hosted on Kubernetes, encode the two generated files into a `Secret` manifest (you only need the `kubectl` command installed on your local system for this, it does *not* need to be connected to any cluster):

    ```bash
    kubectl create secret generic saml2 \
        --output=yaml \
        --dry-run \
        --from-file=SAML2_PRIVATE_KEY=./laddr-slack-private-key.pem \
        --from-file=SAML2_CERTIFICATE=./laddr-slack-public-cert.pem \
        > ./saml2.secret.yaml
    ```

4. If your cluster uses [sealed secrets](http://civic-cloud.phl.io/development/features/sealed-secrets/), seal the newly-created secret:

    ```bash
    export SEALED_SECRETS_CERT=https://sealed-secrets.live.k8s.phl.io/v1/cert.pem
    kubeseal \
        --namespace "my-project" \
        -f ./saml2.secret.yaml \
        -w ./saml2.sealed-secret.yaml
    ```

    *Be sure to replace `my-project` with the namespace your instance is deployed within*

5. Deploy the sealed secret to your cluster

    *In Code for Philly's case, that means updating [`saml2.yaml`](https://github.com/CodeForPhilly/cfp-live-cluster/blob/main/code-for-philly.secrets/saml2.yaml) with the new content and then merging the generated deploy PR. After the deploy, you may need to delete the existing secret in order for the `sealed-secrets` operator to replace it with the updated secret*

6. Finally, visit <https://my-org.slack.com/admin/auth/saml?sudo=1> and edit the **Public Certificate**, pasting the contents of `./laddr-slack-public-cert.pem`:

    ```bash
    cat ./laddr-slack-public-cert.pem
    # paste output to Slack admin webpage
    ```

    *Slack will not let you save the new public certificate until it's been successfully applied to the host*
