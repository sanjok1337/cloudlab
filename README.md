# AWS EKS з Nginx Ingress Controller

Цей проект містить Terraform конфігурацію для розгортання Amazon EKS кластера з Nginx Ingress Controller та AWS Load Balancer.

## Компоненти

- **VPC**: Окремий VPC з публічними та приватними підмережами
- **EKS Cluster**: Managed Kubernetes кластер
- **EKS Node Group**: Managed worker nodes
- **AWS Load Balancer Controller**: Для керування AWS Load Balancers
- **Nginx Ingress Controller**: Для маршрутизації HTTP/HTTPS трафіку

## Передумови

1. AWS CLI встановлений та налаштований
2. Terraform >= 1.0
3. kubectl встановлений
4. Helm CLI встановлений (опціонально)

## Швидкий старт

### 1. Налаштування змінних

Скопіюйте файл прикладу та налаштуйте змінні:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Відредагуйте `terraform.tfvars` під свої потреби.

### 2. Ініціалізація Terraform

```bash
terraform init
```

### 3. Перегляд плану

```bash
terraform plan
```

### 4. Застосування конфігурації

```bash
terraform apply
```

Процес може зайняти 15-20 хвилин.

### 5. Налаштування kubectl

Після завершення розгортання виконайте команду з output:

```bash
aws eks update-kubeconfig --region <your-region> --name <cluster-name>
```

### 6. Перевірка встановлення

Перевірте статус Nginx Ingress:

```bash
kubectl get svc -n ingress-nginx
kubectl get pods -n ingress-nginx
```

Отримайте Load Balancer URL:

```bash
kubectl get svc -n ingress-nginx nginx-ingress-ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Приклад використання Ingress

Створіть файл `example-ingress.yaml`:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-app
  namespace: demo
spec:
  replicas: 2
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: hashicorp/http-echo
        args:
        - "-text=Hello from EKS!"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: hello-service
  namespace: demo
spec:
  type: ClusterIP
  selector:
    app: hello
  ports:
  - port: 80
    targetPort: 5678
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-ingress
  namespace: demo
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hello-service
            port:
              number: 80
```

Застосуйте:

```bash
kubectl apply -f example-ingress.yaml
```

Тестуйте:

```bash
curl http://<LOAD_BALANCER_URL>
```

## Структура файлів

- `provider.tf` - Налаштування провайдерів (AWS, Kubernetes, Helm)
- `variables.tf` - Визначення змінних
- `vpc.tf` - Конфігурація VPC
- `eks.tf` - Конфігурація EKS кластера
- `aws-load-balancer-controller.tf` - AWS Load Balancer Controller
- `nginx-ingress.tf` - Nginx Ingress Controller
- `outputs.tf` - Output значення
- `terraform.tfvars.example` - Приклад змінних

## Змінні

| Назва | Опис | За замовчуванням |
|-------|------|------------------|
| aws_region | AWS регіон | eu-central-1 |
| cluster_name | Назва EKS кластера | my-eks-cluster |
| cluster_version | Версія Kubernetes | 1.28 |
| vpc_cidr | CIDR блок для VPC | 10.0.0.0/16 |
| environment | Середовище | dev |
| node_instance_types | Типи інстансів | ["t3.medium"] |
| node_desired_size | Бажана кількість нод | 2 |
| node_min_size | Мінімальна кількість нод | 1 |
| node_max_size | Максимальна кількість нод | 4 |

## Очищення

Для видалення всіх ресурсів:

```bash
terraform destroy
```

**Увага**: Це видалить всі створені ресурси та дані!

## Вартість

Приблизна вартість використання (за годину, регіон us-east-1):
- EKS Control Plane: ~$0.10/год
- 2x t3.medium nodes: ~$0.08/год
- NAT Gateway: ~$0.045/год
- Network Load Balancer: ~$0.027/год

**Загалом**: ~$0.25/год (~$180/місяць)

## Troubleshooting

### Load Balancer не створюється

Перевірте логи AWS Load Balancer Controller:

```bash
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

### Nginx Ingress pods не запускаються

```bash
kubectl describe pods -n ingress-nginx
kubectl logs -n ingress-nginx deployment/nginx-ingress-ingress-nginx-controller
```

### Проблеми з IRSA

Перевірте ServiceAccount:

```bash
kubectl get sa -n kube-system aws-load-balancer-controller -o yaml
```

## Підтримка

Для питань та проблем створіть issue у репозиторії.
