Для развертывания необходимо в директории ~/.ssh иметь ключи id_rsa и id_rsa.pub

Развертывание инфраструктуры на Yandex cloud посредством Terrafrom производится c помощью скрипта командой

      ./init.sh
      
Во время развертывания необходимо будет ввести:

      Yandex iam token - Токен сервиcного аккаунта для входа. Можно получить командой "yc iam create-token"
      Cloud_id         - Идентификатор облака
      Folder_id        - Идентификаор папки

Установка конфигураций Ansible командой:

      ansible-playbook test_justai_playbook.yml -vv 

Получить ip адреса машин:

      terraform output external_ip_address_monitoring
      terraform output external_ip_address_java_app

Endpoints:

      Prometheus    - https://(terraform output external_ip_address_monitoring):9090 
      Node Exporter - https://(terraform output external_ip_address_java_app):9100
      Java app      - https://(terraform output external_ip_address_java_app):8080/actuator/prometheus
