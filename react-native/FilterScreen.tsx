import React, { useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Switch, ScrollView } from 'react-native';
import { useNavigation, useRoute } from '@react-navigation/native';
import BlueGradientButton from './BlueGradientButton';
import { Filters } from './types';

const FilterScreen: React.FC = () => {
  const navigation = useNavigation();
  const route = useRoute();
  const currentFilters: Filters = route.params?.filters || { agency: null, showOnlyLiked: false };
  const agencies: string[] = route.params?.agencies || [];
  const [selectedAgency, setSelectedAgency] = useState<string | null>(currentFilters.agency);
  const [showOnlyLiked, setShowOnlyLiked] = useState<boolean>(currentFilters.showOnlyLiked);

  const handleRefine = () => {
    navigation.navigate('LaunchList', { filters: { agency: selectedAgency, showOnlyLiked } });
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Text style={styles.title}>Filter Launches</Text>
        <Text style={styles.subtitle}>Select Agency</Text>
        {agencies.map((agency) => (
          <TouchableOpacity
            key={agency}
            style={styles.agencyItem}
            onPress={() => setSelectedAgency(agency === selectedAgency ? null : agency)}
          >
            <Text style={styles.agencyText}>{agency}</Text>
            {selectedAgency === agency && <Text style={styles.checkmark}>✓</Text>}
          </TouchableOpacity>
        ))}
        <View style={styles.switchContainer}>
          <Text style={styles.switchLabel}>Show Only Liked Launches</Text>
          <Switch value={showOnlyLiked} onValueChange={setShowOnlyLiked} />
        </View>
      </ScrollView>
      <View style={styles.buttonContainer}>
        <BlueGradientButton onPress={handleRefine} text="Refine" />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  scrollView: {
    flex: 1,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 16,
    paddingHorizontal: 16,
  },
  subtitle: {
    fontSize: 18,
    color: '#fff',
    marginBottom: 8,
    paddingHorizontal: 16,
  },
  agencyItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 12,
    backgroundColor: '#333',
    borderRadius: 8,
    marginBottom: 8,
    marginHorizontal: 16,
  },
  agencyText: {
    color: '#fff',
  },
  checkmark: {
    color: '#00ff00',
  },
  switchContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 16,
    paddingHorizontal: 16,
  },
  switchLabel: {
    color: '#fff',
    fontSize: 16,
  },
  buttonContainer: {
    padding: 16,
  },
});

export default FilterScreen;