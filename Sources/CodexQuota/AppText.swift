import Foundation

enum AppLanguage: String {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case french = "fr"
    case russian = "ru"
    case german = "de"
    case italian = "it"
    case japanese = "ja"
    case korean = "ko"
    case portuguese = "pt"
    case spanish = "es"

    static func resolve(preferredLanguages: [String]) -> AppLanguage {
        for identifier in preferredLanguages {
            let parts = identifier.replacingOccurrences(of: "_", with: "-")
                .lowercased()
                .split(separator: "-")
            guard let base = parts.first else { continue }

            switch base {
            case "en": return .english
            case "fr": return .french
            case "ru": return .russian
            case "de": return .german
            case "it": return .italian
            case "ja": return .japanese
            case "ko": return .korean
            case "pt": return .portuguese
            case "es": return .spanish
            case "zh":
                return parts.contains("hant") || parts.contains("tw") || parts.contains("hk") || parts.contains("mo")
                    ? .traditionalChinese
                    : .simplifiedChinese
            default: continue
            }
        }
        return .english
    }
}

enum AppText {
    static let language = AppLanguage.resolve(preferredLanguages: Locale.preferredLanguages)
    static let locale = Locale(identifier: language.rawValue)

    static func text(_ key: String) -> String {
        text(key, language: language)
    }

    static func text(_ key: String, language: AppLanguage) -> String {
        translations[key]?[language] ?? additionalTranslations[language]?[key] ?? key
    }

    static func format(_ key: String, _ value: String) -> String {
        text(key).replacingOccurrences(of: "%@", with: value)
    }

    static func count(_ key: String, _ value: Int) -> String {
        text(key).replacingOccurrences(of: "%d", with: String(value))
    }

    static func quotaAccessibility(title: String, remaining: Int?) -> String {
        let value = remaining.map { "\($0)%" } ?? text("Unknown")
        switch language {
        case .english: return "\(title): \(value) remaining"
        case .french: return "\(title) : \(value) restant"
        case .russian: return "\(title) : осталось \(value)"
        case .german: return "\(title): noch \(value)"
        case .italian: return "\(title): \(value) rimanente"
        case .japanese: return "\(title)：残り \(value)"
        case .korean: return "\(title): \(value) 남음"
        case .portuguese: return "\(title): \(value) restante"
        case .spanish: return "\(title): \(value) restante"
        case .simplifiedChinese: return "\(title)剩余\(value)"
        case .traditionalChinese: return "\(title)剩餘\(value)"
        }
    }

    private static let translations: [String: [AppLanguage: String]] = [
        "Codex Quota": [.simplifiedChinese: "Codex 额度", .traditionalChinese: "Codex 額度", .french: "Quota Codex", .russian: "Лимиты Codex"],
        "Updates every minute": [.simplifiedChinese: "每分钟自动更新", .traditionalChinese: "每分鐘自動更新", .french: "Actualisation : 1 min", .russian: "Обновление: 1 мин."],
        "5-hour quota": [.simplifiedChinese: "5 小时额度", .traditionalChinese: "5 小時額度", .french: "Quota de 5 h", .russian: "Лимит на 5 ч"],
        "Weekly quota": [.simplifiedChinese: "每周额度", .traditionalChinese: "每週額度", .french: "Quota hebdomadaire", .russian: "Недельный лимит"],
        "Resets at %@": [.simplifiedChinese: "恢复于 %@", .traditionalChinese: "恢復於 %@", .french: "Récupération : %@", .russian: "Сброс: %@"],
        "Remaining quota": [.simplifiedChinese: "剩余额度", .traditionalChinese: "剩餘額度", .french: "Quota restant", .russian: "Остаток лимита"],
        "Unknown": [.simplifiedChinese: "未知", .traditionalChinese: "未知", .french: "Inconnu", .russian: "Неизвестно"],
        "Use one reset credit?": [.simplifiedChinese: "使用一次重置机会？", .traditionalChinese: "使用一次重置機會？", .french: "Utiliser un crédit de réinitialisation ?", .russian: "Использовать одну попытку сброса?"],
        "Use reset": [.simplifiedChinese: "使用重置", .traditionalChinese: "使用重置", .french: "Réinitialiser", .russian: "Использовать сброс"],
        "Cancel": [.simplifiedChinese: "取消", .traditionalChinese: "取消", .french: "Annuler", .russian: "Отмена"],
        "This will use one reset credit and reset eligible quota.": [.simplifiedChinese: "将消耗 1 次重置机会，并重置当前符合条件的额度。", .traditionalChinese: "將消耗 1 次重置機會，並重置目前符合條件的額度。", .french: "Cela consommera un crédit et réinitialisera les quotas admissibles.", .russian: "Будет использована одна попытка сброса для доступных лимитов."],
        "Refresh": [.simplifiedChinese: "刷新", .traditionalChinese: "重新整理", .french: "Actualiser", .russian: "Обновить"],
        "Refresh quota": [.simplifiedChinese: "刷新额度", .traditionalChinese: "重新整理額度", .french: "Actualiser les quotas", .russian: "Обновить лимиты"],
        "Close floating window": [.simplifiedChinese: "关闭浮窗", .traditionalChinese: "關閉浮動視窗", .french: "Fermer la fenêtre flottante", .russian: "Закрыть плавающее окно"],
        "Open floating window": [.simplifiedChinese: "打开浮窗", .traditionalChinese: "開啟浮動視窗", .french: "Ouvrir la fenêtre flottante", .russian: "Открыть плавающее окно"],
        "Quit": [.simplifiedChinese: "退出", .traditionalChinese: "退出", .french: "Quitter", .russian: "Выйти"],
        "Quit Codex Quota": [.simplifiedChinese: "退出 Codex 额度", .traditionalChinese: "退出 Codex 額度", .french: "Quitter Quota Codex", .russian: "Выйти из Лимитов Codex"],
        "More options": [.simplifiedChinese: "更多选项", .traditionalChinese: "更多選項", .french: "Plus d’options", .russian: "Дополнительные параметры"],
        "Open with ChatGPT": [
            .simplifiedChinese: "ChatGPT 启动时打开",
            .traditionalChinese: "ChatGPT 啟動時開啟",
            .french: "Ouvrir au lancement de ChatGPT",
            .russian: "Открывать при запуске ChatGPT",
            .german: "Beim Start von ChatGPT öffnen",
            .italian: "Apri all’avvio di ChatGPT",
            .japanese: "ChatGPTの起動時に開く",
            .korean: "ChatGPT 시작 시 열기",
            .portuguese: "Abrir ao iniciar o ChatGPT"
        ],
        "Settings": [
            .simplifiedChinese: "设置",
            .traditionalChinese: "設定",
            .french: "Réglages",
            .russian: "Настройки",
            .german: "Einstellungen",
            .italian: "Impostazioni",
            .japanese: "設定",
            .korean: "설정",
            .portuguese: "Definições"
        ],
        "Could not change launch setting.": [
            .simplifiedChinese: "无法更改启动设置。",
            .traditionalChinese: "無法變更啟動設定。",
            .french: "Impossible de modifier le réglage de démarrage.",
            .russian: "Не удалось изменить настройку запуска.",
            .german: "Die Starteinstellung konnte nicht geändert werden.",
            .italian: "Impossibile modificare l’impostazione di avvio.",
            .japanese: "起動設定を変更できませんでした。",
            .korean: "시작 설정을 변경할 수 없습니다.",
            .portuguese: "Não foi possível alterar a definição de arranque."
        ],
        "Drag the title to move this window": [.simplifiedChinese: "拖动标题可移动浮窗", .traditionalChinese: "拖曳標題可移動浮動視窗", .french: "Faites glisser le titre pour déplacer la fenêtre", .russian: "Перетащите заголовок, чтобы переместить окно"],
        "Reset credits": [.simplifiedChinese: "重置机会", .traditionalChinese: "重置機會", .french: "Crédits de réinitialisation", .russian: "Попытки сброса"],
        "Available: %d": [.simplifiedChinese: "可用 %d 次", .traditionalChinese: "可用 %d 次", .french: "Disponible : %d", .russian: "Доступно: %d"],
        "Loading…": [.simplifiedChinese: "正在读取", .traditionalChinese: "讀取中", .french: "Chargement…", .russian: "Загрузка…"],
        "Using…": [.simplifiedChinese: "正在使用…", .traditionalChinese: "使用中…", .french: "Utilisation…", .russian: "Использование…"],
        "Last updated: %@": [.simplifiedChinese: "上次更新  %@", .traditionalChinese: "上次更新  %@", .french: "Dernière mise à jour : %@", .russian: "Обновлено: %@"],
        "Connecting to Codex…": [.simplifiedChinese: "正在连接 Codex…", .traditionalChinese: "正在連線 Codex…", .french: "Connexion à Codex…", .russian: "Подключение к Codex…"],
        "Codex CLI was not found. Please sign in to ChatGPT.": [.simplifiedChinese: "未找到 Codex CLI。请先登录 ChatGPT。", .traditionalChinese: "找不到 Codex CLI。請先登入 ChatGPT。", .french: "Codex CLI est introuvable. Connectez-vous à ChatGPT.", .russian: "Codex CLI не найден. Войдите в ChatGPT."],
        "Quota connection was lost. Click Refresh to try again.": [.simplifiedChinese: "额度连接已断开；点击刷新重试。", .traditionalChinese: "額度連線已中斷；點擊重新整理再試。", .french: "Connexion aux quotas perdue. Cliquez sur Actualiser.", .russian: "Связь с лимитами потеряна. Нажмите «Обновить»."],
        "Connection interrupted. Confirm again to safely retry this reset.": [.simplifiedChinese: "连接中断；再次确认可安全重试本次重置。", .traditionalChinese: "連線中斷；再次確認即可安全重試此次重置。", .french: "Connexion interrompue. Confirmez à nouveau pour réessayer en toute sécurité.", .russian: "Соединение прервано. Подтвердите повторно для безопасного повтора сброса."],
        "Unable to start Codex CLI.": [.simplifiedChinese: "无法启动 Codex CLI。", .traditionalChinese: "無法啟動 Codex CLI。", .french: "Impossible de démarrer Codex CLI.", .russian: "Не удалось запустить Codex CLI."],
        "Could not send a request to Codex.": [.simplifiedChinese: "无法向 Codex 发送请求。", .traditionalChinese: "無法向 Codex 傳送請求。", .french: "Impossible d’envoyer une requête à Codex.", .russian: "Не удалось отправить запрос в Codex."],
        "Timed out while reading quota; values may be outdated.": [.simplifiedChinese: "读取超时；显示值可能已过期。", .traditionalChinese: "讀取逾時；顯示的數值可能已過期。", .french: "Délai de lecture dépassé ; les valeurs peuvent être obsolètes.", .russian: "Истекло время чтения; данные могут быть устаревшими."],
        "The reset result is unconfirmed. Confirm again to retry safely.": [.simplifiedChinese: "重置结果暂未确认；再次确认可安全重试。", .traditionalChinese: "重置結果尚未確認；再次確認即可安全重試。", .french: "Réinitialisation non confirmée. Confirmez à nouveau pour réessayer sans risque.", .russian: "Результат сброса не подтверждён. Подтвердите повторно для безопасного повтора."],
        "Initialization failed. Update Codex CLI.": [.simplifiedChinese: "初始化失败，请更新 Codex CLI。", .traditionalChinese: "初始化失敗，請更新 Codex CLI。", .french: "Échec de l’initialisation. Mettez Codex CLI à jour.", .russian: "Ошибка инициализации. Обновите Codex CLI."],
        "Could not read quota. Make sure you are signed in to ChatGPT.": [.simplifiedChinese: "读取失败，请确认 Codex 已登录 ChatGPT。", .traditionalChinese: "讀取失敗，請確認 Codex 已登入 ChatGPT。", .french: "Lecture impossible. Vérifiez votre connexion à ChatGPT.", .russian: "Не удалось прочитать лимиты. Проверьте вход в ChatGPT."],
        "No quota data was returned; this account may not support it.": [.simplifiedChinese: "未返回额度；当前账户可能不支持。", .traditionalChinese: "未傳回額度；目前帳戶可能不支援。", .french: "Aucune donnée de quota ; ce compte peut ne pas être compatible.", .russian: "Данные лимитов не получены; возможно, аккаунт их не поддерживает."],
        "Reset is unconfirmed. Confirm again to retry safely.": [.simplifiedChinese: "重置尚未确认；可再次确认并安全重试。", .traditionalChinese: "重置尚未確認；可再次確認並安全重試。", .french: "Réinitialisation non confirmée. Confirmez à nouveau pour réessayer sans risque.", .russian: "Сброс не подтверждён. Подтвердите повторно для безопасного повтора."],
        "Reset used. Refreshing quota…": [.simplifiedChinese: "重置已使用，正在更新额度…", .traditionalChinese: "已使用重置，正在更新額度…", .french: "Crédit utilisé. Actualisation des quotas…", .russian: "Попытка использована. Обновление лимитов…"],
        "This reset request was already completed. Refreshing quota…": [.simplifiedChinese: "此重置请求已完成，正在更新额度…", .traditionalChinese: "此重置請求已完成，正在更新額度…", .french: "Cette demande est déjà terminée. Actualisation…", .russian: "Этот запрос уже выполнен. Обновление лимитов…"],
        "No reset credits are currently available.": [.simplifiedChinese: "目前没有可用的重置机会。", .traditionalChinese: "目前沒有可用的重置機會。", .french: "Aucun crédit de réinitialisation disponible.", .russian: "Нет доступных попыток сброса."],
        "There is no quota eligible for reset.": [.simplifiedChinese: "当前额度无需重置。", .traditionalChinese: "目前額度無需重置。", .french: "Aucun quota ne peut être réinitialisé actuellement.", .russian: "Сейчас нет лимитов, доступных для сброса."],
        "Reset was not completed. Confirm again to retry safely.": [.simplifiedChinese: "重置未完成；可再次确认并安全重试。", .traditionalChinese: "重置未完成；可再次確認並安全重試。", .french: "Réinitialisation inachevée. Confirmez à nouveau pour réessayer sans risque.", .russian: "Сброс не завершён. Подтвердите повторно для безопасного повтора."],
        "5-hour quota: %@": [.simplifiedChinese: "5 小时额度：%@", .traditionalChinese: "5 小時額度：%@", .french: "Quota de 5 h : %@", .russian: "Лимит на 5 ч: %@"],
        "Weekly quota: %@": [.simplifiedChinese: "每周额度：%@", .traditionalChinese: "每週額度：%@", .french: "Quota hebdomadaire : %@", .russian: "Недельный лимит: %@"],
        "Reset credits available: %d": [.simplifiedChinese: "可用重置：%d 次", .traditionalChinese: "可用重置：%d 次", .french: "Crédits disponibles : %d", .russian: "Доступно попыток сброса: %d"],
        "Updated: %@": [.simplifiedChinese: "更新于 %@", .traditionalChinese: "更新於 %@", .french: "Mis à jour : %@", .russian: "Обновлено: %@"],
        "Loading quota…": [.simplifiedChinese: "正在读取额度…", .traditionalChinese: "正在讀取額度…", .french: "Chargement des quotas…", .russian: "Загрузка лимитов…"]
    ]

    private static let additionalTranslations: [AppLanguage: [String: String]] = [
        .german: [
            "Codex Quota": "Codex-Limit",
            "Updates every minute": "Wird jede Minute aktualisiert",
            "5-hour quota": "5-Stunden-Limit",
            "Weekly quota": "Wochenlimit",
            "Resets at %@": "Wird um %@ zurückgesetzt",
            "Remaining quota": "Verbleibendes Kontingent",
            "Unknown": "Unbekannt",
            "Use one reset credit?": "Eine Rücksetzoption verwenden?",
            "Use reset": "Zurücksetzen",
            "Cancel": "Abbrechen",
            "This will use one reset credit and reset eligible quota.": "Dabei wird eine Rücksetzoption verbraucht und ein berechtigtes Kontingent zurückgesetzt.",
            "Refresh": "Aktualisieren",
            "Refresh quota": "Kontingent aktualisieren",
            "Close floating window": "Schwebendes Fenster schließen",
            "Open floating window": "Schwebendes Fenster öffnen",
            "Quit": "Beenden",
            "Quit Codex Quota": "Codex-Limit beenden",
            "More options": "Weitere Optionen",
            "Drag the title to move this window": "Fenster am Titel ziehen, um es zu verschieben",
            "Reset credits": "Rücksetzoptionen",
            "Available: %d": "Verfügbar: %d",
            "Loading…": "Wird geladen…",
            "Using…": "Wird verwendet…",
            "Last updated: %@": "Zuletzt aktualisiert: %@",
            "Connecting to Codex…": "Verbindung zu Codex wird hergestellt…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "Codex CLI wurde nicht gefunden. Melde dich bei ChatGPT an.",
            "Quota connection was lost. Click Refresh to try again.": "Die Verbindung zum Kontingent ging verloren. Klicke auf Aktualisieren, um es erneut zu versuchen.",
            "Connection interrupted. Confirm again to safely retry this reset.": "Verbindung unterbrochen. Bestätige erneut, um das Zurücksetzen sicher zu wiederholen.",
            "Unable to start Codex CLI.": "Codex CLI konnte nicht gestartet werden.",
            "Could not send a request to Codex.": "Die Anfrage konnte nicht an Codex gesendet werden.",
            "Timed out while reading quota; values may be outdated.": "Zeitüberschreitung beim Lesen des Kontingents; die Werte sind möglicherweise veraltet.",
            "The reset result is unconfirmed. Confirm again to retry safely.": "Das Zurücksetzen wurde nicht bestätigt. Bestätige erneut, um es sicher zu wiederholen.",
            "Initialization failed. Update Codex CLI.": "Initialisierung fehlgeschlagen. Aktualisiere Codex CLI.",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "Kontingent konnte nicht gelesen werden. Stelle sicher, dass du bei ChatGPT angemeldet bist.",
            "No quota data was returned; this account may not support it.": "Es wurden keine Kontingentdaten zurückgegeben. Dieses Konto unterstützt die Funktion möglicherweise nicht.",
            "Reset is unconfirmed. Confirm again to retry safely.": "Das Zurücksetzen wurde nicht bestätigt. Bestätige erneut, um es sicher zu wiederholen.",
            "Reset used. Refreshing quota…": "Rücksetzoption verwendet. Kontingent wird aktualisiert…",
            "This reset request was already completed. Refreshing quota…": "Diese Rücksetzanforderung wurde bereits ausgeführt. Kontingent wird aktualisiert…",
            "No reset credits are currently available.": "Derzeit sind keine Rücksetzoptionen verfügbar.",
            "There is no quota eligible for reset.": "Derzeit gibt es kein Kontingent, das zurückgesetzt werden kann.",
            "Reset was not completed. Confirm again to retry safely.": "Das Zurücksetzen wurde nicht abgeschlossen. Bestätige erneut, um es sicher zu wiederholen.",
            "5-hour quota: %@": "5-Stunden-Limit: %@",
            "Weekly quota: %@": "Wochenlimit: %@",
            "Reset credits available: %d": "Verfügbare Rücksetzoptionen: %d",
            "Updated: %@": "Aktualisiert: %@",
            "Loading quota…": "Kontingent wird geladen…"
        ],
        .italian: [
            "Codex Quota": "Limite Codex",
            "Updates every minute": "Aggiornamento ogni minuto",
            "5-hour quota": "Limite di 5 ore",
            "Weekly quota": "Limite settimanale",
            "Resets at %@": "Si ripristina alle %@",
            "Remaining quota": "Limite residuo",
            "Unknown": "Sconosciuto",
            "Use one reset credit?": "Usare un credito di ripristino?",
            "Use reset": "Ripristina",
            "Cancel": "Annulla",
            "This will use one reset credit and reset eligible quota.": "Verrà usato un credito di ripristino per reimpostare i limiti idonei.",
            "Refresh": "Aggiorna",
            "Refresh quota": "Aggiorna i limiti",
            "Close floating window": "Chiudi la finestra mobile",
            "Open floating window": "Apri la finestra mobile",
            "Quit": "Esci",
            "Quit Codex Quota": "Esci da Limite Codex",
            "More options": "Altre opzioni",
            "Drag the title to move this window": "Trascina il titolo per spostare la finestra",
            "Reset credits": "Crediti di ripristino",
            "Available: %d": "Disponibili: %d",
            "Loading…": "Caricamento…",
            "Using…": "In uso…",
            "Last updated: %@": "Ultimo aggiornamento: %@",
            "Connecting to Codex…": "Connessione a Codex…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "Codex CLI non è stato trovato. Accedi a ChatGPT.",
            "Quota connection was lost. Click Refresh to try again.": "Connessione ai limiti persa. Fai clic su Aggiorna per riprovare.",
            "Connection interrupted. Confirm again to safely retry this reset.": "Connessione interrotta. Conferma di nuovo per ripetere il ripristino in sicurezza.",
            "Unable to start Codex CLI.": "Impossibile avviare Codex CLI.",
            "Could not send a request to Codex.": "Impossibile inviare una richiesta a Codex.",
            "Timed out while reading quota; values may be outdated.": "Tempo scaduto durante la lettura dei limiti; i valori potrebbero non essere aggiornati.",
            "The reset result is unconfirmed. Confirm again to retry safely.": "Il ripristino non è stato confermato. Conferma di nuovo per riprovare in sicurezza.",
            "Initialization failed. Update Codex CLI.": "Inizializzazione non riuscita. Aggiorna Codex CLI.",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "Impossibile leggere i limiti. Verifica di aver effettuato l’accesso a ChatGPT.",
            "No quota data was returned; this account may not support it.": "Non sono stati restituiti dati sui limiti; questo account potrebbe non supportarli.",
            "Reset is unconfirmed. Confirm again to retry safely.": "Il ripristino non è confermato. Conferma di nuovo per riprovare in sicurezza.",
            "Reset used. Refreshing quota…": "Credito utilizzato. Aggiornamento dei limiti…",
            "This reset request was already completed. Refreshing quota…": "Questa richiesta di ripristino è già stata completata. Aggiornamento…",
            "No reset credits are currently available.": "Al momento non sono disponibili crediti di ripristino.",
            "There is no quota eligible for reset.": "Al momento non ci sono limiti da ripristinare.",
            "Reset was not completed. Confirm again to retry safely.": "Ripristino non completato. Conferma di nuovo per riprovare in sicurezza.",
            "5-hour quota: %@": "Limite di 5 ore: %@",
            "Weekly quota: %@": "Limite settimanale: %@",
            "Reset credits available: %d": "Crediti di ripristino disponibili: %d",
            "Updated: %@": "Aggiornato: %@",
            "Loading quota…": "Caricamento dei limiti…"
        ],
        .japanese: [
            "Codex Quota": "Codex 利用枠",
            "Updates every minute": "毎分自動更新",
            "5-hour quota": "5時間の利用枠",
            "Weekly quota": "週間の利用枠",
            "Resets at %@": "%@ にリセット",
            "Remaining quota": "残りの利用枠",
            "Unknown": "不明",
            "Use one reset credit?": "リセット権を1回使用しますか？",
            "Use reset": "リセットを使用",
            "Cancel": "キャンセル",
            "This will use one reset credit and reset eligible quota.": "リセット権を1回使用し、対象の利用枠をリセットします。",
            "Refresh": "更新",
            "Refresh quota": "利用枠を更新",
            "Close floating window": "フローティングウィンドウを閉じる",
            "Open floating window": "フローティングウィンドウを開く",
            "Quit": "終了",
            "Quit Codex Quota": "Codex 利用枠を終了",
            "More options": "その他のオプション",
            "Drag the title to move this window": "タイトルをドラッグしてウィンドウを移動",
            "Reset credits": "リセット権",
            "Available: %d": "利用可能：%d回",
            "Loading…": "読み込み中…",
            "Using…": "使用中…",
            "Last updated: %@": "最終更新：%@",
            "Connecting to Codex…": "Codex に接続中…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "Codex CLI が見つかりません。ChatGPT にサインインしてください。",
            "Quota connection was lost. Click Refresh to try again.": "利用枠への接続が切断されました。「更新」をクリックして再試行してください。",
            "Connection interrupted. Confirm again to safely retry this reset.": "接続が中断されました。もう一度確認すると安全にリセットを再試行できます。",
            "Unable to start Codex CLI.": "Codex CLI を起動できませんでした。",
            "Could not send a request to Codex.": "Codex にリクエストを送信できませんでした。",
            "Timed out while reading quota; values may be outdated.": "利用枠の読み込みがタイムアウトしました。表示内容が古い可能性があります。",
            "The reset result is unconfirmed. Confirm again to retry safely.": "リセット結果を確認できませんでした。もう一度確認すると安全に再試行できます。",
            "Initialization failed. Update Codex CLI.": "初期化に失敗しました。Codex CLI を更新してください。",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "利用枠を読み取れませんでした。ChatGPT にサインインしていることを確認してください。",
            "No quota data was returned; this account may not support it.": "利用枠のデータがありません。このアカウントは対応していない可能性があります。",
            "Reset is unconfirmed. Confirm again to retry safely.": "リセットを確認できませんでした。もう一度確認すると安全に再試行できます。",
            "Reset used. Refreshing quota…": "リセット権を使用しました。利用枠を更新中…",
            "This reset request was already completed. Refreshing quota…": "このリセット要求はすでに完了しています。利用枠を更新中…",
            "No reset credits are currently available.": "現在利用できるリセット権はありません。",
            "There is no quota eligible for reset.": "現在リセット可能な利用枠はありません。",
            "Reset was not completed. Confirm again to retry safely.": "リセットは完了しませんでした。もう一度確認すると安全に再試行できます。",
            "5-hour quota: %@": "5時間の利用枠：%@",
            "Weekly quota: %@": "週間の利用枠：%@",
            "Reset credits available: %d": "利用可能なリセット権：%d回",
            "Updated: %@": "更新：%@",
            "Loading quota…": "利用枠を読み込み中…"
        ],
        .korean: [
            "Codex Quota": "Codex 한도",
            "Updates every minute": "1분마다 자동 업데이트",
            "5-hour quota": "5시간 한도",
            "Weekly quota": "주간 한도",
            "Resets at %@": "%@에 초기화",
            "Remaining quota": "남은 한도",
            "Unknown": "알 수 없음",
            "Use one reset credit?": "초기화 횟수를 1회 사용하시겠습니까?",
            "Use reset": "초기화 사용",
            "Cancel": "취소",
            "This will use one reset credit and reset eligible quota.": "초기화 횟수 1회를 사용해 해당 한도를 초기화합니다.",
            "Refresh": "새로고침",
            "Refresh quota": "한도 새로고침",
            "Close floating window": "플로팅 윈도우 닫기",
            "Open floating window": "플로팅 윈도우 열기",
            "Quit": "종료",
            "Quit Codex Quota": "Codex 한도 종료",
            "More options": "추가 옵션",
            "Drag the title to move this window": "제목을 드래그해 윈도우 이동",
            "Reset credits": "초기화 횟수",
            "Available: %d": "%d회 사용 가능",
            "Loading…": "불러오는 중…",
            "Using…": "사용 중…",
            "Last updated: %@": "마지막 업데이트: %@",
            "Connecting to Codex…": "Codex에 연결 중…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "Codex CLI를 찾을 수 없습니다. ChatGPT에 로그인해 주세요.",
            "Quota connection was lost. Click Refresh to try again.": "한도 연결이 끊겼습니다. 새로고침을 눌러 다시 시도하세요.",
            "Connection interrupted. Confirm again to safely retry this reset.": "연결이 중단되었습니다. 다시 확인하면 안전하게 초기화를 재시도할 수 있습니다.",
            "Unable to start Codex CLI.": "Codex CLI를 시작할 수 없습니다.",
            "Could not send a request to Codex.": "Codex에 요청을 보낼 수 없습니다.",
            "Timed out while reading quota; values may be outdated.": "한도 읽기 시간이 초과되었습니다. 표시된 값이 최신이 아닐 수 있습니다.",
            "The reset result is unconfirmed. Confirm again to retry safely.": "초기화 결과를 확인하지 못했습니다. 다시 확인하면 안전하게 재시도할 수 있습니다.",
            "Initialization failed. Update Codex CLI.": "초기화에 실패했습니다. Codex CLI를 업데이트해 주세요.",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "한도를 읽을 수 없습니다. ChatGPT에 로그인했는지 확인해 주세요.",
            "No quota data was returned; this account may not support it.": "한도 데이터가 반환되지 않았습니다. 이 계정은 지원되지 않을 수 있습니다.",
            "Reset is unconfirmed. Confirm again to retry safely.": "초기화를 확인하지 못했습니다. 다시 확인하면 안전하게 재시도할 수 있습니다.",
            "Reset used. Refreshing quota…": "초기화 횟수를 사용했습니다. 한도를 새로고침하는 중…",
            "This reset request was already completed. Refreshing quota…": "이 초기화 요청은 이미 완료되었습니다. 한도를 새로고침하는 중…",
            "No reset credits are currently available.": "현재 사용할 수 있는 초기화 횟수가 없습니다.",
            "There is no quota eligible for reset.": "현재 초기화할 수 있는 한도가 없습니다.",
            "Reset was not completed. Confirm again to retry safely.": "초기화가 완료되지 않았습니다. 다시 확인하면 안전하게 재시도할 수 있습니다.",
            "5-hour quota: %@": "5시간 한도: %@",
            "Weekly quota: %@": "주간 한도: %@",
            "Reset credits available: %d": "사용 가능한 초기화 횟수: %d회",
            "Updated: %@": "업데이트: %@",
            "Loading quota…": "한도를 불러오는 중…"
        ],
        .portuguese: [
            "Codex Quota": "Cota do Codex",
            "Updates every minute": "Atualização a cada minuto",
            "5-hour quota": "Cota de 5 horas",
            "Weekly quota": "Cota semanal",
            "Resets at %@": "Reinicia às %@",
            "Remaining quota": "Cota restante",
            "Unknown": "Desconhecido",
            "Use one reset credit?": "Usar um crédito de reposição?",
            "Use reset": "Repor",
            "Cancel": "Cancelar",
            "This will use one reset credit and reset eligible quota.": "Será usado um crédito de reposição para repor a cota elegível.",
            "Refresh": "Atualizar",
            "Refresh quota": "Atualizar cota",
            "Close floating window": "Fechar janela flutuante",
            "Open floating window": "Abrir janela flutuante",
            "Quit": "Sair",
            "Quit Codex Quota": "Sair da Cota do Codex",
            "More options": "Mais opções",
            "Drag the title to move this window": "Arraste o título para mover esta janela",
            "Reset credits": "Créditos de reposição",
            "Available: %d": "Disponível: %d",
            "Loading…": "A carregar…",
            "Using…": "A utilizar…",
            "Last updated: %@": "Última atualização: %@",
            "Connecting to Codex…": "A ligar ao Codex…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "O Codex CLI não foi encontrado. Inicie sessão no ChatGPT.",
            "Quota connection was lost. Click Refresh to try again.": "A ligação à cota foi perdida. Selecione Atualizar para tentar novamente.",
            "Connection interrupted. Confirm again to safely retry this reset.": "Ligação interrompida. Confirme novamente para repetir a reposição em segurança.",
            "Unable to start Codex CLI.": "Não foi possível iniciar o Codex CLI.",
            "Could not send a request to Codex.": "Não foi possível enviar um pedido ao Codex.",
            "Timed out while reading quota; values may be outdated.": "Tempo limite ao ler a cota; os valores podem estar desatualizados.",
            "The reset result is unconfirmed. Confirm again to retry safely.": "A reposição não foi confirmada. Confirme novamente para tentar em segurança.",
            "Initialization failed. Update Codex CLI.": "Falha na inicialização. Atualize o Codex CLI.",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "Não foi possível ler a cota. Confirme que tem sessão iniciada no ChatGPT.",
            "No quota data was returned; this account may not support it.": "Não foram recebidos dados da cota; esta conta poderá não ser compatível.",
            "Reset is unconfirmed. Confirm again to retry safely.": "A reposição não foi confirmada. Confirme novamente para tentar em segurança.",
            "Reset used. Refreshing quota…": "Crédito utilizado. A atualizar a cota…",
            "This reset request was already completed. Refreshing quota…": "Este pedido de reposição já foi concluído. A atualizar a cota…",
            "No reset credits are currently available.": "Não há créditos de reposição disponíveis neste momento.",
            "There is no quota eligible for reset.": "Não há cotas elegíveis para reposição neste momento.",
            "Reset was not completed. Confirm again to retry safely.": "A reposição não foi concluída. Confirme novamente para tentar em segurança.",
            "5-hour quota: %@": "Cota de 5 horas: %@",
            "Weekly quota: %@": "Cota semanal: %@",
            "Reset credits available: %d": "Créditos de reposição disponíveis: %d",
            "Updated: %@": "Atualizado: %@",
            "Loading quota…": "A carregar a cota…"
        ],
        .spanish: [
            "Codex Quota": "Cuota de Codex",
            "Updates every minute": "Actualización cada minuto",
            "5-hour quota": "Cuota de 5 horas",
            "Weekly quota": "Cuota semanal",
            "Resets at %@": "Se restablece el %@",
            "Remaining quota": "Cuota restante",
            "Unknown": "Desconocido",
            "Use one reset credit?": "¿Usar un crédito de restablecimiento?",
            "Use reset": "Restablecer",
            "Cancel": "Cancelar",
            "This will use one reset credit and reset eligible quota.": "Se consumirá un crédito de restablecimiento y se restablecerá la cuota que cumpla los requisitos.",
            "Refresh": "Actualizar",
            "Refresh quota": "Actualizar cuota",
            "Close floating window": "Cerrar ventana flotante",
            "Open floating window": "Abrir ventana flotante",
            "Quit": "Salir",
            "Quit Codex Quota": "Salir de Cuota de Codex",
            "More options": "Más opciones",
            "Open with ChatGPT": "Abrir al iniciar ChatGPT",
            "Settings": "Ajustes",
            "Could not change launch setting.": "No se pudo cambiar el ajuste de inicio.",
            "Drag the title to move this window": "Arrastra el título para mover esta ventana",
            "Reset credits": "Créditos de restablecimiento",
            "Available: %d": "Disponibles: %d",
            "Loading…": "Cargando…",
            "Using…": "Restableciendo…",
            "Last updated: %@": "Última actualización: %@",
            "Connecting to Codex…": "Conectando con Codex…",
            "Codex CLI was not found. Please sign in to ChatGPT.": "No se encontró Codex CLI. Inicia sesión en ChatGPT.",
            "Quota connection was lost. Click Refresh to try again.": "Se perdió la conexión con la cuota. Pulsa Actualizar para volver a intentarlo.",
            "Connection interrupted. Confirm again to safely retry this reset.": "Conexión interrumpida. Confirma de nuevo para reintentar este restablecimiento de forma segura.",
            "Unable to start Codex CLI.": "No se pudo iniciar Codex CLI.",
            "Could not send a request to Codex.": "No se pudo enviar una solicitud a Codex.",
            "Timed out while reading quota; values may be outdated.": "Se agotó el tiempo de espera al consultar la cuota; los valores podrían estar desactualizados.",
            "The reset result is unconfirmed. Confirm again to retry safely.": "No se ha confirmado el resultado del restablecimiento. Confirma de nuevo para reintentarlo de forma segura.",
            "Initialization failed. Update Codex CLI.": "Error de inicialización. Actualiza Codex CLI.",
            "Could not read quota. Make sure you are signed in to ChatGPT.": "No se pudo consultar la cuota. Comprueba que has iniciado sesión en ChatGPT.",
            "No quota data was returned; this account may not support it.": "No se recibieron datos de cuota; es posible que esta cuenta no sea compatible.",
            "Reset is unconfirmed. Confirm again to retry safely.": "El restablecimiento no está confirmado. Confirma de nuevo para reintentarlo de forma segura.",
            "Reset used. Refreshing quota…": "Crédito consumido. Actualizando cuota…",
            "This reset request was already completed. Refreshing quota…": "Esta solicitud de restablecimiento ya se completó. Actualizando cuota…",
            "No reset credits are currently available.": "No hay créditos de restablecimiento disponibles en este momento.",
            "There is no quota eligible for reset.": "No hay ninguna cuota que se pueda restablecer.",
            "Reset was not completed. Confirm again to retry safely.": "El restablecimiento no se completó. Confirma de nuevo para reintentarlo de forma segura.",
            "5-hour quota: %@": "Cuota de 5 horas: %@",
            "Weekly quota: %@": "Cuota semanal: %@",
            "Reset credits available: %d": "Créditos de restablecimiento disponibles: %d",
            "Updated: %@": "Actualizado: %@",
            "Loading quota…": "Cargando cuota…"
        ]
    ]

}
