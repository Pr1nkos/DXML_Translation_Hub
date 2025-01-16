# ENG

# DXML Translation Hub by Pr1nkos

**DXML Translation Hub** is a powerful tool for automatic translation of in-game texts, designed to work with a large number of mods. The mod allows adding translations on top of existing files without overwriting them, making it an ideal solution for modders and translators.

With **DXML Translation Hub**, you can easily add missing translations, update existing ones, and apply them in the game without compromising the integrity of the original files. The mod supports working with XML files in the `gamedata/configs/text/eng` and `gamedata/configs/text/rus` folders and provides the ability to dynamically add translations.

---

## Features

- **Support for a large number of mods**: The mod does not overwrite original files but adds translations on top of them.
- **Automatic addition of missing translations**: The mod scans XML files and automatically adds strings for which translations are missing.
- **Dynamic application of translations**: Translations are applied when the game is launched from the `dynamic_translations_rus` folder.
- **Flexible configuration**: You can configure the logging level, paths to translation folders, and other parameters.
- **Uniqueness**: The mod is developed by **Pr1nkos** and is focused on ease of use for modders and translators.

---

## Installation

### Method 1: Installation via Mod Organizer 2 (MO2)
1. Add the mod to MO2 as a regular mod.
2. Activate the mod in the list of installed mods.

### Method 2: Manual Installation
1. Copy the `gamedata` folder from the mod archive to the root directory of your game.
2. Ensure that the folder and file structure is preserved:
   ```
   gamedata/
   └── scripts/
       └── xml_translator/
           ├── config/
           ├── logs/
           ├── utils/
           └── *.lua
   ```

---

## Configuration

The main settings of the mod are located in the `xml_translator_config.lua` file. You can change the following parameters:

- **USE_STATIC_LOG_NAME**: If `true`, the log file name will be static (`xml_translator.log`). If `false`, the date and time will be added to the file name.
- **ENABLE_LOGGING**: Enable or disable logging.
- **LOG_LEVEL**: Logging level (1 — DEBUG, 2 — INFO, 3 — WARNING, 4 — ERROR).
- **LANGUAGE**: Translation language (currently only `rus` is supported).
- **DYNAMIC_TRANSLATIONS_DIR**: Path to the folder with dynamic translations.
- **MISSING_TRANSLATIONS_DIR**: Path to the folder with missing translations.

---

## Instructions for Modders

### 1. Adding Translations for Your Mod

If you are creating a mod and want to add translation support via **DXML Translation Hub**, follow these steps:

1. **Create XML files**: Ensure that your mod's text data is stored in XML files in the `gamedata/configs/text/eng` folder.
2. **Add translations**: Place translation files in the `dynamic_translations_rus` folder. The file name must match the name of the original XML file but with the `.lua` extension. For example, for the file `example.xml`, create a file `example.lua`.
3. **Translation file format**: The translation file should return a Lua table where the keys are `string_id` and the values are texts in Russian. Example:
   ```lua
   return {
       ["string_1"] = "Привет, мир!",
       ["string_2"] = "Это пример перевода.",
   }
   ```

### 2. Automatic Addition of Missing Translations

If your mod contains strings for which translations are missing, **DXML Translation Hub** will automatically add them to the `missing_translations_rus` folder. You can use these files to fill in the translations.

### 3. Applying Translations

All translation files from the `dynamic_translations_rus` folder are applied automatically when the game is launched. This allows adding translations without the need to overwrite original files.

---

## How It Works

1. **File scanning**: The mod scans files in `gamedata/configs/text/eng` and `gamedata/configs/text/rus`.
2. **Finding missing translations**: If strings without translations are found in the `gamedata/configs/text/eng` file, they are added to the corresponding file in the `missing_translations_rus` folder.
3. **Applying translations**: If there are translation files in the `dynamic_translations_rus` folder, they are applied to the corresponding strings in the `gamedata/configs/text/rus` files.

---

## Logs

Logs are stored in the `logs` folder. You can use them for debugging and checking the mod's operation. Example log:

```
[2023-10-01 12:34:56] [INFO] Registering on_xml_read callback
[2023-10-01 12:34:56] [DEBUG] on_xml_read callback triggered for file: gamedata/configs/text/eng/example.xml
[2023-10-01 12:34:56] [INFO] Successfully loaded translations from: gamedata/scripts/xml_translator/dynamic_translations_rus/example.lua
```

---

## Support

If you have any questions or issues with using the mod, please contact the author (**Dr.Pr1nkos**) in Discord or create an issue in the project repository.

---


# RUS

# DXML Translation Hub by Pr1nkos

**DXML Translation Hub** — это мощный инструмент для автоматического перевода текстов в игре, ориентированный на работу с большим количеством модов. Мод позволяет добавлять переводы поверх существующих файлов, не перезаписывая их, что делает его идеальным решением для модмейкеров и переводчиков. 

С помощью **DXML Translation Hub** вы можете легко добавлять отсутствующие переводы, обновлять существующие и применять их в игре, не нарушая целостность оригинальных файлов. Мод поддерживает работу с XML-файлами в папках `gamedata/configs/text/eng` и `gamedata/configs/text/rus`, а также предоставляет возможность динамического добавления переводов.

---

## Особенности

- **Поддержка большого количества модов**: Мод не перезаписывает оригинальные файлы, а добавляет переводы поверх них.
- **Автоматическое добавление отсутствующих переводов**: Мод сканирует XML-файлы и автоматически добавляет строки, для которых отсутствуют переводы.
- **Динамическое применение переводов**: Переводы применяются при запуске игры из папки `dynamic_translations_rus`.
- **Гибкая настройка**: Вы можете настроить уровень логирования, пути к папкам с переводами и другие параметры.
- **Уникальность**: Мод разработан **Pr1nkos** и ориентирован на удобство использования для модмейкеров и переводчиков.

---

## Установка

### Способ 1: Установка через Mod Organizer 2 (MO2)
1. Добавьте мод в MO2 как обычный мод.
2. Активируйте мод в списке установленных модов.

### Способ 2: Ручная установка
1. Скопируйте папку `gamedata` из архива мода в корневую директорию вашей игры.
2. Убедитесь, что структура папок и файлов сохранена:
   ```
   gamedata/
   └── scripts/
       └── xml_translator/
           ├── config/
           ├── logs/
           ├── utils/
           └── *.lua
   ```

---

## Настройка

Основные настройки мода находятся в файле `xml_translator_config.lua`. Вы можете изменить следующие параметры:

- **USE_STATIC_LOG_NAME**: Если `true`, имя лог-файла будет статическим (`xml_translator.log`). Если `false`, к имени файла будет добавлена дата и время.
- **ENABLE_LOGGING**: Включение или отключение логирования.
- **LOG_LEVEL**: Уровень логирования (1 — DEBUG, 2 — INFO, 3 — WARNING, 4 — ERROR).
- **LANGUAGE**: Язык перевода (в настоящее время поддерживается только `rus`).
- **DYNAMIC_TRANSLATIONS_DIR**: Путь к папке с динамическими переводами.
- **MISSING_TRANSLATIONS_DIR**: Путь к папке с отсутствующими переводами.

---

## Инструкция для модмейкеров

### 1. Добавление переводов для вашего мода

Если вы создаете мод и хотите добавить поддержку переводов через **DXML Translation Hub**, выполните следующие шаги:

1. **Создайте XML-файлы**: Убедитесь, что текстовые данные вашего мода хранятся в XML-файлах в папке `gamedata/configs/text/eng`.
2. **Добавьте переводы**: Поместите файлы с переводами в папку `dynamic_translations_rus`. Имя файла должно совпадать с именем оригинального XML-файла, но с расширением `.lua`. Например, для файла `example.xml` создайте файл `example.lua`.
3. **Формат файла с переводами**: Файл с переводами должен возвращать таблицу Lua, где ключи — это `string_id`, а значения — тексты на русском языке. Пример:
   ```lua
   return {
       ["string_1"] = "Привет, мир!",
       ["string_2"] = "Это пример перевода.",
   }
   ```

### 2. Автоматическое добавление отсутствующих переводов

Если в вашем моде есть строки, для которых отсутствуют переводы, **DXML Translation Hub** автоматически добавит их в папку `missing_translations_rus`. Вы можете использовать эти файлы для заполнения переводов.

### 3. Применение переводов

Все файлы с переводами из папки `dynamic_translations_rus` применяются автоматически при запуске игры. Это позволяет добавлять переводы без необходимости перезаписи оригинальных файлов.

---

## Пример работы

1. **Сканирование файлов**: Мод сканирует файлы в `gamedata/configs/text/eng` и `gamedata/configs/text/rus`.
2. **Поиск отсутствующих переводов**: Если в файле `gamedata/configs/text/eng` найдены строки без перевода, они добавляются в соответствующий файл в папке `missing_translations_rus`.
3. **Применение переводов**: Если в папке `dynamic_translations_rus` есть файлы с переводами, они применяются к соответствующим строкам в файлах `gamedata/configs/text/rus`.

---

## Логи

Логи хранятся в папке `logs`. Вы можете использовать их для отладки и проверки работы мода. Пример лога:

```
[2023-10-01 12:34:56] [INFO] Registering on_xml_read callback
[2023-10-01 12:34:56] [DEBUG] on_xml_read callback triggered for file: gamedata/configs/text/eng/example.xml
[2023-10-01 12:34:56] [INFO] Successfully loaded translations from: gamedata/scripts/xml_translator/dynamic_translations_rus/example.lua
```

---

## Поддержка

Если у вас возникли вопросы или проблемы с использованием мода, пожалуйста, свяжитесь с автором (**Dr.Pr1nkos**) в дискорде или создайте issue в репозитории проекта.
