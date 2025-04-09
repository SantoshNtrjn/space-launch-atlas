import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  FlatList,
  ActivityIndicator,
  StyleSheet,
  RefreshControl,
  TouchableOpacity,
  Alert,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import LaunchCard from './LaunchCard';
import BlueGradientButton from './BlueGradientButton';
import { Launch, Filters } from './types';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useNavigation, useRoute } from '@react-navigation/native';

const LaunchListScreen: React.FC = () => {
  const navigation = useNavigation();
  const route = useRoute();
  const [launches, setLaunches] = useState<Launch[]>([]);
  const [filteredLaunches, setFilteredLaunches] = useState<Launch[]>([]);
  const [offset, setOffset] = useState<number>(0);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [refreshing, setRefreshing] = useState<boolean>(false);
  const [likedLaunches, setLikedLaunches] = useState<string[]>([]);
  const [filters, setFilters] = useState<Filters>({ agency: null, showOnlyLiked: false });
  const [agencies, setAgencies] = useState<string[]>([]);

  useEffect(() => {
    loadLikedLaunches();
    fetchLaunches();
  }, []);

  useEffect(() => {
    if (route.params?.filters) {
      setFilters(route.params.filters);
    }
  }, [route.params?.filters]);

  useEffect(() => {
    applyFilters();
  }, [launches, likedLaunches, filters]);

  useEffect(() => {
    const uniqueAgencies = Array.from(new Set(launches.map((launch) => launch.launch_service_provider.name)));
    setAgencies(uniqueAgencies);
  }, [launches]);

  const loadLikedLaunches = async () => {
    try {
      const liked = await AsyncStorage.getItem('likedLaunches');
      if (liked) {
        setLikedLaunches(JSON.parse(liked));
      }
    } catch (e) {
      console.error('Failed to load liked launches', e);
    }
  };

  const saveLikedLaunches = async (newLiked: string[]) => {
    try {
      await AsyncStorage.setItem('likedLaunches', JSON.stringify(newLiked));
    } catch (e) {
      console.error('Failed to save liked launches', e);
    }
  };

  const toggleLike = (launchId: string) => {
    const newLiked = likedLaunches.includes(launchId)
      ? likedLaunches.filter((id) => id !== launchId)
      : [...likedLaunches, launchId];
    setLikedLaunches(newLiked);
    saveLikedLaunches(newLiked);
  };

  const fetchLaunches = async (reset: boolean = false, retries = 3, delay = 2000) => {
    if (isLoading) return;
    setIsLoading(true);
    const currentOffset = reset ? 0 : offset;
    const url = `https://ll.thespacedevs.com/2.2.0/launch/upcoming/?limit=10&offset=${currentOffset}`;

    const attemptFetch = async (attempt: number): Promise<void> => {
      try {
        const response = await fetch(url);
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        const data = await response.json();
        // Ensure data.results is an array; default to empty array if undefined
        const results = Array.isArray(data.results) ? data.results : [];
        setLaunches(reset ? results : [...launches, ...results]);
        if (!reset) setOffset(currentOffset + 10);
        setIsLoading(false);
        if (reset) setRefreshing(false);
      } catch (e: any) {
        if (attempt < retries) {
          console.log(`Retry ${attempt + 1}/${retries} after ${delay}ms...`);
          await new Promise((resolve) => setTimeout(resolve, delay));
          return attemptFetch(attempt + 1);
        } else {
          Alert.alert('Error', `Failed to load launches after ${retries} attempts: ${e.message}`);
          if (reset) setLaunches([]);
          setIsLoading(false);
          if (reset) setRefreshing(false);
        }
      }
    };

    await attemptFetch(0);
  };

  const applyFilters = () => {
    let filtered = [...launches];
    if (filters.agency) {
      filtered = filtered.filter((launch) => launch.launch_service_provider.name === filters.agency);
    }
    if (filters.showOnlyLiked) {
      filtered = filtered.filter((launch) => likedLaunches.includes(launch.id));
    }
    setFilteredLaunches(filtered);
  };

  const handleRefresh = () => {
    setRefreshing(true);
    fetchLaunches(true);
  };

  const handleFilterPress = () => {
    navigation.navigate('Filter', { filters, agencies });
  };

  const renderItem = ({ item }: { item: Launch }) => (
    <LaunchCard launch={item} isLiked={likedLaunches.includes(item.id)} toggleLike={toggleLike} />
  );

  return (
    <View style={styles.container}>
      <LinearGradient colors={['#37474f', '#000000']} style={styles.header}>
        <Text style={styles.headerText}>Space Launch Atlas</Text>
        <TouchableOpacity onPress={handleFilterPress} style={styles.buttonContainer}>
          <Text style={styles.filterButton}>Filter</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={handleRefresh} style={styles.buttonContainer}>
          <Text style={styles.refreshButton}>Refresh</Text>
        </TouchableOpacity>
      </LinearGradient>
      {filteredLaunches.length === 0 && filters.showOnlyLiked ? (
        <Text style={styles.noLikedText}>You haven't liked any launches yet.</Text>
      ) : (
        <FlatList
          data={filteredLaunches}
          renderItem={renderItem}
          keyExtractor={(item) => item.id}
          ListEmptyComponent={
            isLoading && launches.length === 0 ? (
              <ActivityIndicator size="large" color="#00ffff" />
            ) : null
          }
          ListFooterComponent={() =>
            isLoading && launches.length > 0 ? (
              <ActivityIndicator size="large" color="#00ffff" />
            ) : (
              <BlueGradientButton onPress={() => fetchLaunches()} text="Load More" />
            )
          }
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={handleRefresh} />
          }
          contentContainerStyle={styles.listContent}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  header: {
    padding: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
  },
  filterButton: {
    fontSize: 16,
    color: '#fff',
  },
  refreshButton: {
    fontSize: 16,
    color: '#fff',
  },
  buttonContainer: {
    padding: 10,
  },
  listContent: {
    paddingBottom: 16,
  },
  noLikedText: {
    color: '#fff',
    textAlign: 'center',
    marginTop: 20,
  },
});

export default LaunchListScreen;