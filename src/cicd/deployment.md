# Actuele deployment

De basis van onze applicatie zijn de volgende manifest yamls:

## Applicatie

Aangezien we deze applicatie via ArgoCD deployen hebben wij natuurlijk een app.yaml:

```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    argocd-image-updater.argoproj.io/image-list: sdomain=delsynn/sdo:latest
    argocd-image-updater.argoproj.io/sdomain.update-strategy: digest
    argocd-image-updater.argoproj.io/git-branch: main
    argocd-image-updater.argoproj.io/write-back-method: git
  name: sdomain
  namespace: argo
spec:
  destination:
    namespace: sdomain
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: https://github.com/Cloud-Computing-2324/evaluation-smoothdevoperators.git
    path: overlays/main
    targetRevision: HEAD
  info:
    - name: 'sdomain'
      value: 'https://sdomain.38.cc.ucll.cloud'
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Zoals men kan zien zijn er annotaties voor Argo Image Updater, hier komen wij later op terug.

Bij de metadata kan men zien dat dit wordt toegekend aan de Argo namespace, zo kan ArgoCD deze applicatie terugvinden en daardoor zal deze dan ook zichtbaar zijn de ArgoCD GUI.

Bij spec kan men zien waar men deze applicatie zal deployen, aangezien wij ge-authenticate zijn met de cluster via de kube_config file gebruiken wij dan ook het lokale adres : https://kubernetes.default.svc

Voor de syncronisatie van ArgoCD te kunnen gebruiken moeten wij het pad naar onze repo hier ook zetten.

En wij kiezen een url waarop wij deze site kunnen bezoeken.

Als laatste dan nog, kunnen wij hier al zetten dat deze applicatie automatisch moet syncroniseren en prunen.

## Deployment

In de deployment yaml gaan wij dan de naam van de applicatie bepalen, welke image wij gebruiken (in ons geval dus onze eigen image) en hoeveel resources deze deployment mag gebruiken van de cluster:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sdomain
  namespace: sdomain
spec:
  replicas: 0
  selector:
    matchLabels:
      app: sdomain
  template:
    metadata:
      labels:
        app: sdomain
    spec:
      containers:
      - image: delsynn/sdo:latest
        imagePullPolicy: Always
        name: sdowebsite
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "128Mi"
            cpu: "50m"
```

We kunnen hier het aantal replicas bepalen en zoals u ziet steken we deze ook in de sdomain namespace, waarin wij alle resources hebben gestoken (ingress, service, podscaler, rollout, enz...).

## Ingress

Om onze website te kunnen bereiken moeten wij een ingress aanmaken:

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sdomain-ingress
  namespace: sdomain
spec:
  rules:
  - host: sdomain.38.cc.ucll.cloud
    http:
      paths:
      - backend:
          service:
            name: sdomain-service
            port:
              number: 80
        path: /
        pathType: Prefix
```

Hier bepalen wij nogmaals de url waarop deze website bereikbaar is en de achterliggende service naar welke de binnenkomende trafiek zal verstuurd worden.

Het "path" zal dan weer bepalen waar op de site men terecht komt.

## Service

Zoals al vermeld zal de binnenkomende trafiek verstuurd worden naar de service van de applicatie en deze stuurt de trafiek dan door naar de applicatie zelf:

```
apiVersion: v1
kind: Service
metadata:
  name: sdomain-service
  namespace: sdomain
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: sdomain
```

Deze gaat bepalen welke poorten gaan gebruikt worden, aangezien het over een nginx website gaat gebruiken we dus poort 80 en binden deze ook aan gewoon poort 80.

Met deze yaml bestanden hebben wij de basis setup.

Aangezien wij deze deployen op ArgoCD zullen veranderingen aan deze bestanden automatisch gesynced worden wanneer Argo hier veranderingen aan ziet in onze repository.