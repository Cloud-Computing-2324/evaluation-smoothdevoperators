![Smooth](../smooth.png)

# CI/CD Introductie

Interpretatie

## Testing pipelines

Aangezien we Mdbook gebruiken, hebben we tests nodig die te maken hebben met markdown files. Deze tests runnen we in de workflow files, die worden ge-depoloyed na het pushen.
Indien deze tests falen, wordt dit aangegeven in de build op GitHub Actions en wordt de build by-default gestopt.
We kunnen zowel voor deze als voor andere tests kiezen om de build al dan niet te laten falen als er fouten inzitten. Wij kiezen ervoor om de build toe te laten om dan zelf te gaan kijken welke fouten erin zitten, door de line "continue-on-error: true" toe te voegen. 

## Package building pipelines

Ons doel is door middel van GitHub Actions een CI/CD omgeving op te zetten waarbij elke aanpassing de we uitvoeren, automatisch wordt aangepast in de actieve build van het programma.
In onze repository voegen we hiervoor een aantal workflow files toe die geactiveerd worden wanneer de aanpassingen worden gepusht op GitHub. Voor 'dev', 'qa' en 'main' voegen we dit soort files toe. De image op Docker Hub wordt geüpdatet naar de nieuwe versie wanneer deze wordt gebuild. Hierdoor zal de website of configuratie in de actieve omgeving de aanpassingen tonen.

## Deployment of packages to their respective environments

Ondanks dat de applicaties van dev, qa en main op dezelfde cluster staan gebruiken we andere configuraties voor deze applicaties. Ze hebben een ander doel, en dus andere benodigdheden. Door middel van yaml files worden ze in aparte omgevingen opgezet op ArgoCD, en zijn ze ook toegankelijk op andere links. In de app.yaml file wordt de GitHub repo toegewezen, en die is in theorie voor alle omgevingen hetzelfde. We hebben echter gekozen om zoveel mogelijk te onderscheiden tussen de omgevingen, zo zitten de pods in andere namespaces, hebben ze een andere link zoals eerder vermeld, hebben de applicaties een andere naam, uiteraard gebruiken ze een andere image, etc. .

## Argo rollouts

Op de main branch hebben we Canary deployments. Die zorgen voor gecontroleerde aanpassingen, waardoor we de aanpassingen in een productieomgeving in real-time zouden kunnen monitoren. Hierdoor kunnen we er sneller achterkomen of er nog fouten in de nieuwe versie zitten.

## ArgoCD

Zoals te zien is in onze workflow files worden er enkel aanpassingen gepusht naar de Docker Hub image. ArgoCD gaat zelf op basis van de yaml files van qa, dev en main de configuraties ophalen om te deployen.