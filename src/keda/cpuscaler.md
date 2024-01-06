# Keda CPU-Scaler

Volgens de officiële website van Keda heeft de cpu scaler enkele vereisten:

![CPU scaler vereisten](cpuscalerprerequisites.png)

Zoals men kan zien heeft deze scaler de Kubernetes Metrics Server nodig vooraleer deze kan werken, gelukkige was deze al standaard geïnstalleerd op onze cluster:

![Metrics Server](metricsserver.png)

De tweede vereiste is dat onze deployments wel degelijk resources hebben die kunnen gemonitored worden door deze scaler, zoals u kan zien in onze deployment yaml, zijn deze ook aanwezig:

![Deployment Resources](deploymentresources.png)

We hebben vrij weinig resources toegekent per pod aangezien het over een simpele website als deze gaat en enkel wij momenteel de website bezoeken.