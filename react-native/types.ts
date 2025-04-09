export interface Launch {
  id: string;
  name: string;
  net: string;
  image?: string;
  launch_service_provider: {
    name: string;
  };
  mission?: {
    description: string;
  };
  vid_urls?: Array<{ url: string }>;
  info_urls?: string[];
}

export interface Filters {
  agency: string | null;
  showOnlyLiked: boolean;
}