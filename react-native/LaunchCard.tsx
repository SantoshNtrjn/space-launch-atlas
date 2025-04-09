import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  Image,
  TouchableOpacity,
  StyleSheet,
  Linking,
  Alert,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import GradientButton from './GradientButton';
import { Launch } from './types';

interface LaunchCardProps {
  launch: Launch;
  isLiked: boolean;
  toggleLike: (launchId: string) => void;
}

const LaunchCard: React.FC<LaunchCardProps> = ({ launch, isLiked, toggleLike }) => {
  const [countdown, setCountdown] = useState<string>('');

  useEffect(() => {
    const updateCountdown = () => {
      const launchTime = new Date(launch.net);
      const now = new Date();
      const difference = launchTime.getTime() - now.getTime();
      if (difference < 0) {
        setCountdown('Launched');
      } else {
        const days = Math.floor(difference / (1000 * 60 * 60 * 24));
        const hours = Math.floor((difference / (1000 * 60 * 60)) % 24);
        const minutes = Math.floor((difference / (1000 * 60)) % 60);
        const seconds = Math.floor((difference / 1000) % 60);
        setCountdown(
          `${days}:${hours.toString().padStart(2, '0')}:${minutes
            .toString()
            .padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`
        );
      }
    };
    updateCountdown();
    const interval = setInterval(updateCountdown, 1000);
    return () => clearInterval(interval);
  }, [launch.net]);

  const getSourceInfo = (): { url: string; label: string } => {
    const videoUrls = launch.vid_urls || [];
    const infoUrls = launch.info_urls || [];
    const missionName = launch.name || 'Unknown Mission';
    const agencyName = launch.launch_service_provider.name || 'Unknown Agency';

    if (videoUrls.length > 0) {
      return { url: videoUrls[0].url, label: 'Watch Live' };
    } else if (infoUrls.length > 0) {
      return { url: infoUrls[0], label: 'Read More' };
    } else {
      const searchQuery = encodeURIComponent(`${missionName} ${agencyName} mission details`);
      return {
        url: `https://www.chatgpt.com/search?q=${searchQuery}`, // Updated to Google since ChatGPT URL is invalid
        label: 'Mission Info',
      };
    }
  };

  const sourceInfo = getSourceInfo();
  const imageUrl = launch.image || 'https://via.placeholder.com/150?text=No+Image';

  const handlePress = async () => {
    try {
      await Linking.openURL(sourceInfo.url);
    } catch (e: any) {
      Alert.alert('Error', `Could not open URL: ${e.message}`);
    }
  };

  return (
    <LinearGradient
      colors={['#424242', '#212121']}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
      style={styles.card}
    >
      <View style={styles.cardContent}>
        <Image source={{ uri: imageUrl }} style={styles.image} onError={() => {}} />
        <View style={styles.textContainer}>
          <Text style={styles.title}>{launch.name}</Text>
          <Text style={styles.subtitle}>
            Agency: {launch.launch_service_provider.name}
          </Text>
          <Text style={styles.countdown}>Countdown: {countdown}</Text>
          <Text style={styles.description}>
            {launch.mission
              ? launch.mission.description
              : 'No mission details available.'}
          </Text>
          <View style={styles.buttonContainer}>
            <GradientButton onPress={handlePress} text={sourceInfo.label} />
            <TouchableOpacity onPress={() => toggleLike(launch.id)}>
              <Text style={styles.likeButton}>{isLiked ? '❤️' : '🤍'}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  card: {
    marginVertical: 8,
    marginHorizontal: 16,
    borderRadius: 16,
    elevation: 4,
  },
  cardContent: {
    flexDirection: 'row',
    padding: 16,
  },
  image: {
    width: 80,
    height: 80,
    borderRadius: 8,
  },
  textContainer: {
    flex: 1,
    marginLeft: 16,
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
  },
  subtitle: {
    fontSize: 16,
    color: '#ccc',
  },
  countdown: {
    fontSize: 18,
    color: '#00ff00',
    marginTop: 4,
  },
  description: {
    fontSize: 16,
    color: '#aaa',
    marginTop: 8,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: 12,
  },
  likeButton: {
    fontSize: 24,
  },
});

export default LaunchCard;