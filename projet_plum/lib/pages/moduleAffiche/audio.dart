import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'playerAudio.dart' as p;
import 'package:rxdart/rxdart.dart' as x;
//import 'package:get/get.dart';

class Audio extends StatefulWidget {
  final String lien;
  const Audio({Key? key, required this.lien}) : super(key: key);

  @override
  AudioState createState() => AudioState();
}

class AudioState extends State<Audio> with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    p.ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Informez le système d'exploitation des attributs audio de notre application, etc.
    // Nous choisissons une valeur par défaut raisonnable pour une application qui lit la parole.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Le lien de l'audio

    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(
          'http://13.39.81.126:7002${widget.lien}'
          //"https://file-examples.com/storage/fe04183d33637128a9c93a7/2017/11/file_example_WAV_1MG.wav"
          )));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Relâchez les décodeurs et les tampons au système d'exploitation, ce qui les rend
    // disponible pour d'autres applications à utiliser.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Libère les ressources du lecteur lorsqu'elles ne sont pas utilisées. Nous utilisons "stop" pour que
      // si l'application reprend plus tard, elle se souviendra toujours de la position à
      // reprendre à partir de.
      _player.stop();
    }
  }

  /// Collecte les données utiles pour l'affichage dans une barre de recherche, à l'aide d'un outil pratique
  /// fonctionnalité de rx_dart pour combiner les 3 flux d'intérêt en un seul.
  Stream<p.PositionData> get _positionDataStream =>
      x.Rx.combineLatest3<Duration, Duration, Duration?, p.PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => p.PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage('assets/audio.jpg'),
              opacity: 100,
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.audiotrack,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            // Affiche le bouton de lecture/pause et les curseurs de volume/vitesse.
            ControlButtons(_player),
            // Affiche la barre de recherche. En utilisant StreamBuilder, ce widget reconstruit
            // chaque fois que la position, la position tamponnée ou la durée change.
            StreamBuilder<p.PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return p.SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: _player.seek,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Boutton play/pause/volume/rapidité .
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ouvrir le dialogue pour le volume
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            p.showSliderDialog(
              context: context,
              title: "Ajuster le volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        SizedBox(
          width: 20,
        ),

        /// Ce StreamBuilder se reconstruit chaque fois que l'état du lecteur change, ce qui
        /// inclut l'état de lecture/pause ainsi que l'état
        /// chargement/mise en mémoire tampon/état prêt. En fonction de l'état, nous montrons le
        /// bouton ou indicateur de chargement approprié.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                color: Colors.white,
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        SizedBox(
          width: 20,
        ),
        // Ouvrir le dialogue pour la rapidité
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: () {
              p.showSliderDialog(
                context: context,
                title: "Ajuster la rapidité",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}
