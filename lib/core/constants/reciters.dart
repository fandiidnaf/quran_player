/// Qari / Reciter definitions.
/// Maps to "artist" in the music player analogy.
class Reciter {
  final String id;
  final String name;

  const Reciter({required this.id, required this.name});
}

const List<Reciter> kReciters = [
  Reciter(id: 'ar.alafasy', name: 'Mishary Rashid Alafasy'),
  // Reciter(id: 'ar.abdulbasit', name: 'Abdul Basit Abdul Samad'),
  // Reciter(id: 'ar.saadalghamdi', name: 'Saad Al-Ghamdi'),
  // Reciter(id: 'ar.maheralmuaiqly', name: 'Maher Al-Muaiqly'),
];

/// Assign a reciter to each surah in a round-robin pattern.
Reciter reciterFor(int surahNumber) =>
    kReciters[(surahNumber - 1) % kReciters.length];
