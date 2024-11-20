export interface CleanUserFilesResult {
    updatedUsers: string[];
    errors: string[];
}

export interface CleanUserFilesFeature {
    removeFileReferences(userUidList: string[], fileUid: string): Promise<CleanUserFilesResult>;
}