# Org Level Setting

## 1. Setup Github Apps
```
Orgaization Setting -> Developer Setting -> Github Apps -> New Github APP
```

```
Set Github App name, Homepage URL

Required Permissions for Org Runners:
Repository Permissions

Actions (read)
Metadata (read)

Organization Permissions

Self-hosted runners (read / write)
```

## 2. Install Github Apps

![image](https://user-images.githubusercontent.com/50174803/172144149-5fd5c987-a2db-4b8e-a4a2-368bbc0c1441.png)
![image](https://user-images.githubusercontent.com/50174803/172144246-d78c7796-738c-435a-90e7-e7d0979d6147.png)

## 3. Check org/repo
![image](https://user-images.githubusercontent.com/50174803/172144325-c84f115c-ed27-42f4-8c63-bd7253009b85.png)

## 4. kubectl create secret
```
kubectl create secret generic controller-manager \
    -n actions-runner-system \
    --from-literal=github_app_id=${APP_ID} \
    --from-literal=github_app_installation_id=${INSTALLATION_ID} \
    --from-file=github_app_private_key=${PRIVATE_KEY_FILE_PATH}
```

## 5. Result 

[ POD ] 
![image](https://user-images.githubusercontent.com/50174803/172144718-0b66d007-4429-42c0-bda6-03d42601aaa6.png)

[ Org Runner ]
![image](https://user-images.githubusercontent.com/50174803/172144824-99f14a22-87cf-46c6-ba9f-ad5f273b4d35.png)

[ Org/repo : github-runner-org ]
![image](https://user-images.githubusercontent.com/50174803/172145014-1385a12e-811e-49c4-a276-d647d5f27b9f.png)
![image](https://user-images.githubusercontent.com/50174803/172145132-54a33e3b-60f4-4fc9-87d7-2149051c6b2c.png)
![image](https://user-images.githubusercontent.com/50174803/172145170-e72ed01b-4e8a-41d1-a0be-9e5a25272d62.png)

