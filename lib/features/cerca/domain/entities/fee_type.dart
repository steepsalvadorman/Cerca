/// Which Cerca service fee applies, depending on how the job was arranged.
enum FeeType { direct, bidding, project }

class FeeConfig {
  const FeeConfig({required this.title, required this.amount, required this.desc});

  final String title;
  final int amount;
  final String desc;
}
