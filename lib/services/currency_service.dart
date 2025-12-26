// Service simple pour gérer la monnaie affichée dans l'application.
// - Les prix des produits sont toujours stockés en USD (dans le modèle).
// - La conversion se fait uniquement à l'affichage via ce service.

enum Currency { usd, fc }

class CurrencyService {
  // Singleton pour partager l'état de la monnaie courante facilement dans l'app.
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  // Monnaie actuelle (modifiable via setCurrency)
  Currency _current = Currency.usd;

  // Taux de change configurable (1 USD = usdToFcRate FC)
  // Changez cette valeur ici pour mettre à jour le taux globalement.
  double usdToFcRate = 2500.0;

  // Accesseurs
  Currency get current => _current;
  void setCurrency(Currency c) => _current = c;

  // Retourne le symbole pour la monnaie courante
  String get symbol {
    switch (_current) {
      case Currency.fc:
        return 'FC';
      case Currency.usd:
      default:
        return r'\$';
    }
  }

  /// Convertit un prix donné (en USD) dans la monnaie courante.
  double convertFromUsd(double usd) {
    if (_current == Currency.fc) return usd * usdToFcRate;
    return usd; // USD -> USD
  }

  /// Formatte un prix (fourni en USD) pour l'affichage selon la monnaie courante.
  String format(double usd, {int decimals = 2}) {
    final value = convertFromUsd(usd);
    final formatted = value.toStringAsFixed(decimals);

    if (_current == Currency.fc) {
      // FC placed after the number (e.g., "2500.00 FC")
      return '$formatted ${symbol}';
    }

    // USD with $ prefix
    return '${symbol}$formatted';
  }
}
