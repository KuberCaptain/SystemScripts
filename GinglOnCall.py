from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time
import winsound

# Настройка Selenium
chrome_options = Options()
chrome_options.add_argument("--headless")  # Фоновый режим
chrome_service = Service("/path/to/chromedriver")  # Укажите путь к chromedriver

driver = webdriver.Chrome(service=chrome_service, options=chrome_options)

# URL приложения во внутренней сети
url = "http://yk-bbrt-front/ITNVPlatform/BBRT"
driver.get(url)

# Функция для проверки значения
def check_for_call():
    try:
        element = driver.find_element(By.CLASS_NAME, "rt-td")
        value = element.text.strip()
        if value in ["1", "2", "3"]:
            return True
        return False
    except Exception as e:
        print(f"Ошибка: {e}")
        return False

# Основной цикл
try:
    while True:
        if check_for_call():
            print("Обнаружен звонок!")
            winsound.Beep(1000, 300)
        time.sleep(3)
except KeyboardInterrupt:
    print("Мониторинг завершён.")
finally:
    driver.quit()
