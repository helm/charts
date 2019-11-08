helm del kubeinvaders --purge
helm install --set-string target_namespace="kubeinvaders\,fooo" --name kubeinvaders --namespace fooo .

