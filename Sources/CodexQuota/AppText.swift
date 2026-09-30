import Foundation

enum AppLanguage: String {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case french = "fr"
    case russian = "ru"

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
        translations[key]?[language] ?? key
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
}
